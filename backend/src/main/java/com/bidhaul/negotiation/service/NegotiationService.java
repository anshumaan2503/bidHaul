package com.bidhaul.negotiation.service;

import com.bidhaul.bid.entity.BidEntity;
import com.bidhaul.bid.enums.BidStatus;
import com.bidhaul.bid.repository.BidRepository;
import com.bidhaul.common.enums.UserType;
import com.bidhaul.negotiation.dto.request.CreateNegotiationOfferRequestDto;
import com.bidhaul.negotiation.dto.request.CreateNegotiationRequestDto;
import com.bidhaul.negotiation.dto.response.NegotiationOfferResponseDto;
import com.bidhaul.negotiation.dto.response.NegotiationResponseDto;
import com.bidhaul.negotiation.entity.Negotiation;
import com.bidhaul.negotiation.entity.NegotiationOffer;
import com.bidhaul.negotiation.enums.NegotiationStatus;
import com.bidhaul.negotiation.repository.NegotiationOfferRepository;
import com.bidhaul.negotiation.repository.NegotiationRepository;
import com.bidhaul.security.util.SecurityUtils;
import com.bidhaul.tender.entity.TenderEntity;
import com.bidhaul.tender.enums.TenderStatus;
import com.bidhaul.user.entity.UserEntity;
import com.bidhaul.user.repository.UserRepository;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.time.Instant;
import java.util.List;
import java.util.UUID;

@Service
public class NegotiationService {

    private final NegotiationRepository negotiationRepository;
    private final NegotiationOfferRepository offerRepository;
    private final BidRepository bidRepository;
    private final UserRepository userRepository;

    public NegotiationService(
            NegotiationRepository negotiationRepository,
            NegotiationOfferRepository offerRepository,
            BidRepository bidRepository,
            UserRepository userRepository
    ) {
        this.negotiationRepository = negotiationRepository;
        this.offerRepository = offerRepository;
        this.bidRepository = bidRepository;
        this.userRepository = userRepository;
    }

    @Transactional
    public NegotiationResponseDto createNegotiation(
            CreateNegotiationRequestDto request
    ) {

        UUID companyId = getCurrentUserId();

        UserEntity company = getUser(companyId);

        if (company.getUserType() != UserType.COMPANY) {
            throw new ResponseStatusException(
                    HttpStatus.FORBIDDEN,
                    "Only company users can start negotiations"
            );
        }

        BidEntity bid = bidRepository.findById(request.bidId())
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.NOT_FOUND,
                        "Bid not found"
                ));

        if (bid.getStatus() != BidStatus.ACCEPTED) {
            throw new ResponseStatusException(
                    HttpStatus.CONFLICT,
                    "Negotiation can only be started for a qualified bid"
            );
        }

        TenderEntity tender = bid.getTender();

        if (tender.getStatus() != TenderStatus.COMPLETED) {
            throw new ResponseStatusException(
                    HttpStatus.CONFLICT,
                    "Negotiation can only start after tender closure"
            );
        }

        if (!tender.getCompany().getId().equals(companyId)) {
            throw new ResponseStatusException(
                    HttpStatus.FORBIDDEN,
                    "You can only negotiate on your own tender"
            );
        }

        if (negotiationRepository.existsByBidId(bid.getId())) {
            throw new ResponseStatusException(
                    HttpStatus.CONFLICT,
                    "A negotiation already exists for this bid"
            );
        }

        Negotiation negotiation = new Negotiation();

        negotiation.setTenderId(tender.getId());
        negotiation.setBidId(bid.getId());
        negotiation.setCompanyId(companyId);
        negotiation.setTransporterId(
                bid.getTransporter().getId()
        );
        negotiation.setStatus(NegotiationStatus.OPEN);

        Negotiation saved =
                negotiationRepository.save(negotiation);

        NegotiationOffer initialOffer =
                new NegotiationOffer();

        initialOffer.setNegotiationId(saved.getId());
        initialOffer.setOfferedBy(companyId);
        initialOffer.setAmount(bid.getAmount());

        String remarks = request.remarks();

        if (remarks == null || remarks.isBlank()) {
            remarks = "Initial offer based on qualified bid";
        } else {
            remarks = remarks.trim();
        }

        initialOffer.setRemarks(remarks);

        offerRepository.save(initialOffer);

        return toResponse(saved);
    }

    @Transactional
    public NegotiationResponseDto addOffer(
            UUID negotiationId,
            CreateNegotiationOfferRequestDto request
    ) {

        UUID userId = getCurrentUserId();

        Negotiation negotiation =
                findNegotiationById(negotiationId);

        ensureParticipant(negotiation, userId);

        if (negotiation.getStatus() != NegotiationStatus.OPEN) {
            throw new ResponseStatusException(
                    HttpStatus.CONFLICT,
                    "Negotiation is no longer open"
            );
        }

        NegotiationOffer latestOffer =
                getLatestOffer(negotiationId);

        if (latestOffer.getOfferedBy().equals(userId)) {
            throw new ResponseStatusException(
                    HttpStatus.CONFLICT,
                    "Wait for the other party to respond"
            );
        }

        NegotiationOffer offer =
                new NegotiationOffer();

        offer.setNegotiationId(negotiationId);
        offer.setOfferedBy(userId);
        offer.setAmount(request.amount());
        offer.setRemarks(request.remarks().trim());

        offerRepository.save(offer);

        return toResponse(negotiation);
    }

    @Transactional
    public NegotiationResponseDto acceptNegotiation(
            UUID negotiationId
    ) {

        UUID userId = getCurrentUserId();

        Negotiation negotiation =
                findNegotiationById(negotiationId);

        ensureParticipant(negotiation, userId);

        if (negotiation.getStatus() != NegotiationStatus.OPEN) {
            throw new ResponseStatusException(
                    HttpStatus.CONFLICT,
                    "Negotiation is no longer open"
            );
        }

        NegotiationOffer latestOffer =
                getLatestOffer(negotiationId);

        if (latestOffer.getOfferedBy().equals(userId)) {
            throw new ResponseStatusException(
                    HttpStatus.CONFLICT,
                    "You cannot accept your own offer"
            );
        }

        negotiation.setStatus(
                NegotiationStatus.ACCEPTED
        );

        negotiation.setFinalAmount(
                latestOffer.getAmount()
        );

        negotiation.setAcceptedBy(userId);
        negotiation.setClosedAt(Instant.now());

        Negotiation saved =
                negotiationRepository.save(negotiation);

        return toResponse(saved);
    }

    @Transactional
    public NegotiationResponseDto rejectNegotiation(
            UUID negotiationId
    ) {

        UUID userId = getCurrentUserId();

        Negotiation negotiation =
                findNegotiationById(negotiationId);

        ensureParticipant(negotiation, userId);

        if (negotiation.getStatus() != NegotiationStatus.OPEN) {
            throw new ResponseStatusException(
                    HttpStatus.CONFLICT,
                    "Negotiation is no longer open"
            );
        }

        negotiation.setStatus(
                NegotiationStatus.REJECTED
        );

        negotiation.setClosedAt(Instant.now());

        Negotiation saved =
                negotiationRepository.save(negotiation);

        return toResponse(saved);
    }

    @Transactional(readOnly = true)
    public NegotiationResponseDto getNegotiation(
            UUID negotiationId
    ) {

        UUID userId = getCurrentUserId();

        Negotiation negotiation =
                findNegotiationById(negotiationId);

        ensureParticipant(negotiation, userId);

        return toResponse(negotiation);
    }

    @Transactional(readOnly = true)
    public List<NegotiationResponseDto> getMyNegotiations() {

        UUID userId = getCurrentUserId();

        UserEntity user = getUser(userId);

        List<Negotiation> negotiations;

        if (user.getUserType() == UserType.COMPANY) {

            negotiations =
                    negotiationRepository
                            .findByCompanyIdOrderByCreatedAtDesc(
                                    userId
                            );

        } else if (
                user.getUserType() == UserType.TRANSPORTER
        ) {

            negotiations =
                    negotiationRepository
                            .findByTransporterIdOrderByCreatedAtDesc(
                                    userId
                            );

        } else {

            throw new ResponseStatusException(
                    HttpStatus.FORBIDDEN,
                    "This user type cannot access negotiations"
            );
        }

        return negotiations.stream()
                .map(this::toResponse)
                .toList();
    }

    @Transactional(readOnly = true)
    public List<NegotiationResponseDto> getTenderNegotiations(
            UUID tenderId
    ) {

        UUID userId = getCurrentUserId();

        List<Negotiation> negotiations =
                negotiationRepository
                        .findByTenderIdOrderByCreatedAtAsc(
                                tenderId
                        );

        for (Negotiation negotiation : negotiations) {
            ensureParticipant(
                    negotiation,
                    userId
            );
        }

        return negotiations.stream()
                .map(this::toResponse)
                .toList();
    }

    private Negotiation findNegotiationById(
            UUID negotiationId
    ) {

        return negotiationRepository
                .findById(negotiationId)
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.NOT_FOUND,
                        "Negotiation not found"
                ));
    }

    private NegotiationOffer getLatestOffer(
            UUID negotiationId
    ) {

        return offerRepository
                .findTopByNegotiationIdOrderByCreatedAtDesc(
                        negotiationId
                )
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.INTERNAL_SERVER_ERROR,
                        "Negotiation has no offers"
                ));
    }

    private void ensureParticipant(
            Negotiation negotiation,
            UUID userId
    ) {

        boolean isCompany =
                negotiation.getCompanyId().equals(userId);

        boolean isTransporter =
                negotiation.getTransporterId().equals(userId);

        if (!isCompany && !isTransporter) {
            throw new ResponseStatusException(
                    HttpStatus.FORBIDDEN,
                    "You are not a participant in this negotiation"
            );
        }
    }

    private UUID getCurrentUserId() {

        return SecurityUtils.getCurrentUserId()
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.UNAUTHORIZED,
                        "Authentication required"
                ));
    }

    private UserEntity getUser(UUID userId) {

        return userRepository
                .findById(userId)
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.NOT_FOUND,
                        "Authenticated user not found"
                ));
    }

    private NegotiationResponseDto toResponse(
            Negotiation negotiation
    ) {

        List<NegotiationOffer> offers =
                offerRepository
                        .findByNegotiationIdOrderByCreatedAtAsc(
                                negotiation.getId()
                        );

        List<NegotiationOfferResponseDto> offerResponses =
                offers.stream()
                        .map(this::toOfferResponse)
                        .toList();

        NegotiationOffer latest =
                offers.isEmpty()
                        ? null
                        : offers.get(offers.size() - 1);

        return new NegotiationResponseDto(
                negotiation.getId(),
                negotiation.getTenderId(),
                negotiation.getBidId(),
                negotiation.getCompanyId(),
                negotiation.getTransporterId(),
                negotiation.getStatus(),
                latest != null
                        ? latest.getAmount()
                        : null,
                latest != null
                        ? latest.getOfferedBy()
                        : null,
                negotiation.getFinalAmount(),
                negotiation.getAcceptedBy(),
                negotiation.getClosedAt(),
                negotiation.getCreatedAt(),
                negotiation.getUpdatedAt(),
                offerResponses
        );
    }

    private NegotiationOfferResponseDto toOfferResponse(
            NegotiationOffer offer
    ) {

        String name =
                userRepository
                        .findById(offer.getOfferedBy())
                        .map(UserEntity::getFullName)
                        .orElse("Unknown User");

        return new NegotiationOfferResponseDto(
                offer.getId(),
                offer.getOfferedBy(),
                name,
                offer.getAmount(),
                offer.getRemarks(),
                offer.getCreatedAt()
        );
    }
}