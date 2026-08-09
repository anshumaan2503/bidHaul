package com.bidhaul.bid.service;

import com.bidhaul.bid.dto.request.CreateBidRequestDto;
import com.bidhaul.bid.dto.response.BidResponseDto;
import com.bidhaul.bid.entity.BidEntity;
import com.bidhaul.bid.enums.BidStatus;
import com.bidhaul.bid.repository.BidRepository;
import com.bidhaul.security.util.SecurityUtils;
import com.bidhaul.tender.entity.TenderEntity;
import com.bidhaul.tender.enums.TenderStatus;
import com.bidhaul.tender.repository.TenderRepository;
import com.bidhaul.user.entity.UserEntity;
import com.bidhaul.user.repository.UserRepository;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.math.BigDecimal;
import java.util.List;
import java.util.UUID;

@Service
public class BidService {

    private final BidRepository bidRepository;
    private final TenderRepository tenderRepository;
    private final UserRepository userRepository;
    private final BigDecimal minimumDecrement;

    public BidService(
            BidRepository bidRepository,
            TenderRepository tenderRepository,
            UserRepository userRepository,
            @Value("${bid.minimum-decrement:500.00}")
            BigDecimal minimumDecrement
    ) {
        this.bidRepository = bidRepository;
        this.tenderRepository = tenderRepository;
        this.userRepository = userRepository;
        this.minimumDecrement = minimumDecrement;
    }

    @Transactional
    public BidResponseDto placeBid(
            UUID tenderId,
            CreateBidRequestDto request
    ) {

        UUID transporterId = SecurityUtils.getCurrentUserId()
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.UNAUTHORIZED,
                        "Authentication required"
                ));

        UserEntity transporter = userRepository.findById(transporterId)
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.NOT_FOUND,
                        "Authenticated user not found"
                ));

        if (transporter.getUserType() == null ||
                !transporter.getUserType().name().equals("TRANSPORTER")) {

            throw new ResponseStatusException(
                    HttpStatus.FORBIDDEN,
                    "Only transporter users can place bids"
            );
        }

        /*
         * Pessimistic lock prevents concurrent bidders from validating
         * against the same stale lowest-bid value.
         */
        TenderEntity tender = tenderRepository.findByIdForUpdate(tenderId)
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.NOT_FOUND,
                        "Tender not found"
                ));

        if (tender.getStatus() != TenderStatus.LIVE) {
            throw new ResponseStatusException(
                    HttpStatus.CONFLICT,
                    "Bidding is not active for this tender"
            );
        }

        if (tender.getCompany().getId().equals(transporterId)) {
            throw new ResponseStatusException(
                    HttpStatus.FORBIDDEN,
                    "A company cannot bid on its own tender"
            );
        }

        BigDecimal bidAmount = request.amount();

        if (bidAmount.compareTo(tender.getCeilingBudget()) >= 0) {
            throw new ResponseStatusException(
                    HttpStatus.BAD_REQUEST,
                    "Bid amount must be lower than the tender budget"
            );
        }

        BidEntity lowestBid = bidRepository
                .findTopByTenderIdAndStatusOrderByAmountAscCreatedAtAsc(
                        tenderId,
                        BidStatus.PENDING
                )
                .orElse(null);

        if (lowestBid != null) {

            BigDecimal requiredMaximum = lowestBid
                    .getAmount()
                    .subtract(minimumDecrement);

            if (bidAmount.compareTo(requiredMaximum) > 0) {
                throw new ResponseStatusException(
                        HttpStatus.BAD_REQUEST,
                        "Bid must be at least "
                                + minimumDecrement
                                + " lower than the current lowest bid"
                );
            }
        }

        BidEntity bid = new BidEntity();

        bid.setBidNumber(generateBidNumber());
        bid.setTender(tender);
        bid.setTransporter(transporter);
        bid.setAmount(bidAmount);
        bid.setEstimatedDays(request.estimatedDays());
        bid.setRemarks(request.remarks().trim());
        bid.setStatus(BidStatus.PENDING);

        return BidResponseDto.from(
                bidRepository.save(bid)
        );
    }

    @Transactional(readOnly = true)
    public List<BidResponseDto> getTenderBids(UUID tenderId) {

        if (!tenderRepository.existsById(tenderId)) {
            throw new ResponseStatusException(
                    HttpStatus.NOT_FOUND,
                    "Tender not found"
            );
        }

        return bidRepository
                .findByTenderIdOrderByAmountAscCreatedAtAsc(tenderId)
                .stream()
                .map(BidResponseDto::from)
                .toList();
    }

    @Transactional(readOnly = true)
    public List<BidResponseDto> getMyBids() {

        UUID transporterId = SecurityUtils.getCurrentUserId()
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.UNAUTHORIZED,
                        "Authentication required"
                ));

        return bidRepository
                .findByTransporterIdOrderByCreatedAtDesc(transporterId)
                .stream()
                .map(BidResponseDto::from)
                .toList();
    }

    private String generateBidNumber() {

        return "BID-" +
                UUID.randomUUID()
                        .toString()
                        .substring(0, 8)
                        .toUpperCase();
    }
}