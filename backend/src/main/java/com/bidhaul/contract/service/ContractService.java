package com.bidhaul.contract.service;

import com.bidhaul.bid.entity.BidEntity;
import com.bidhaul.bid.enums.BidStatus;
import com.bidhaul.bid.repository.BidRepository;
import com.bidhaul.contract.dto.request.AcceptContractRequestDto;
import com.bidhaul.contract.dto.response.CompetitiveBidResponseDto;
import com.bidhaul.contract.dto.response.ContractResponseDto;
import com.bidhaul.contract.entity.ContractEntity;
import com.bidhaul.contract.enums.ContractStatus;
import com.bidhaul.contract.repository.ContractRepository;
import com.bidhaul.delivery.entity.DeliveryEntity;
import com.bidhaul.delivery.service.DeliveryService;
import com.bidhaul.negotiation.entity.Negotiation;
import com.bidhaul.negotiation.enums.NegotiationStatus;
import com.bidhaul.negotiation.repository.NegotiationOfferRepository;
import com.bidhaul.negotiation.repository.NegotiationRepository;
import com.bidhaul.security.util.SecurityUtils;
import com.bidhaul.tender.entity.TenderEntity;
import com.bidhaul.tender.enums.TenderStatus;
import com.bidhaul.tender.repository.TenderRepository;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.Instant;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Service
public class ContractService {

    private final ContractRepository contractRepository;
    private final TenderRepository tenderRepository;
    private final BidRepository bidRepository;
    private final NegotiationRepository negotiationRepository;
    private final NegotiationOfferRepository negotiationOfferRepository;
    private final DeliveryService deliveryService;

    public ContractService(
            ContractRepository contractRepository,
            TenderRepository tenderRepository,
            BidRepository bidRepository,
            NegotiationRepository negotiationRepository,
            NegotiationOfferRepository negotiationOfferRepository,
            DeliveryService deliveryService
    ) {
        this.contractRepository = contractRepository;
        this.tenderRepository = tenderRepository;
        this.bidRepository = bidRepository;
        this.negotiationRepository = negotiationRepository;
        this.negotiationOfferRepository =
                negotiationOfferRepository;
        this.deliveryService = deliveryService;
    }

    @Transactional(readOnly = true)
    public List<CompetitiveBidResponseDto> getCompetitiveStatement(
            UUID tenderId
    ) {

        UUID companyId = getCurrentUserId();

        TenderEntity tender = findTender(tenderId);

        ensureTenderOwner(
                tender,
                companyId
        );

        if (tender.getStatus() != TenderStatus.COMPLETED) {
            throw new ResponseStatusException(
                    HttpStatus.CONFLICT,
                    "Competitive statement is available only after auction closure"
            );
        }

        List<BidEntity> qualifiedBids =
                bidRepository
                        .findByTenderIdAndStatusOrderByAmountAscCreatedAtAsc(
                                tenderId,
                                BidStatus.ACCEPTED
                        );

        List<CompetitiveBidResponseDto> result =
                new ArrayList<>();

        int rank = 1;

        for (BidEntity bid : qualifiedBids) {

            if (rank > 5) {
                break;
            }

            result.add(
                    toCompetitiveBid(
                            bid,
                            rank
                    )
            );

            rank++;
        }

        return result;
    }

    @Transactional
    public ContractResponseDto awardTender(
            UUID tenderId,
            UUID negotiationId,
            String terms
    ) {

        UUID companyId = getCurrentUserId();

        TenderEntity tender =
                tenderRepository.findByIdForUpdate(tenderId)
                        .orElseThrow(() ->
                                new ResponseStatusException(
                                        HttpStatus.NOT_FOUND,
                                        "Tender not found"
                                )
                        );

        ensureTenderOwner(
                tender,
                companyId
        );

        if (tender.getStatus() != TenderStatus.COMPLETED) {
            throw new ResponseStatusException(
                    HttpStatus.CONFLICT,
                    "Only completed tenders can be awarded"
            );
        }

        if (terms == null || terms.isBlank()) {
            throw new ResponseStatusException(
                    HttpStatus.BAD_REQUEST,
                    "Contract terms are required"
            );
        }

        if (contractRepository.existsByTenderId(tenderId)) {
            throw new ResponseStatusException(
                    HttpStatus.CONFLICT,
                    "A contract already exists for this tender"
            );
        }

        Negotiation negotiation =
                negotiationRepository.findById(
                                negotiationId
                        )
                        .orElseThrow(() ->
                                new ResponseStatusException(
                                        HttpStatus.NOT_FOUND,
                                        "Negotiation not found"
                                )
                        );

        if (!negotiation.getTenderId().equals(tenderId)) {
            throw new ResponseStatusException(
                    HttpStatus.BAD_REQUEST,
                    "Negotiation does not belong to this tender"
            );
        }

        if (!negotiation.getCompanyId().equals(companyId)) {
            throw new ResponseStatusException(
                    HttpStatus.FORBIDDEN,
                    "You can only award negotiations belonging to your tender"
            );
        }

        if (negotiation.getStatus() !=
                NegotiationStatus.ACCEPTED) {

            throw new ResponseStatusException(
                    HttpStatus.CONFLICT,
                    "Only an accepted negotiation can be awarded"
            );
        }

        if (negotiation.getFinalAmount() == null ||
                negotiation.getFinalAmount()
                        .compareTo(BigDecimal.ZERO) <= 0) {

            throw new ResponseStatusException(
                    HttpStatus.CONFLICT,
                    "Accepted negotiation does not have a valid final amount"
            );
        }

        BidEntity bid =
                bidRepository.findById(
                                negotiation.getBidId()
                        )
                        .orElseThrow(() ->
                                new ResponseStatusException(
                                        HttpStatus.NOT_FOUND,
                                        "Bid not found"
                                )
                        );

        if (!bid.getTender().getId().equals(tenderId)) {
            throw new ResponseStatusException(
                    HttpStatus.BAD_REQUEST,
                    "Negotiation bid does not belong to this tender"
            );
        }

        if (bid.getStatus() != BidStatus.ACCEPTED) {
            throw new ResponseStatusException(
                    HttpStatus.CONFLICT,
                    "Only a qualified Top 5 bid can be awarded"
            );
        }

        if (!bid.getTransporter().getId().equals(
                negotiation.getTransporterId()
        )) {

            throw new ResponseStatusException(
                    HttpStatus.CONFLICT,
                    "Negotiation transporter does not match the selected bid"
            );
        }

        BigDecimal finalAmount =
                negotiation.getFinalAmount()
                        .setScale(
                                2,
                                RoundingMode.HALF_UP
                        );

        ContractEntity contract =
                ContractEntity.builder()
                        .contractNumber(
                                generateContractNumber()
                        )
                        .tenderId(tenderId)
                        .bidId(bid.getId())
                        .negotiationId(
                                negotiation.getId()
                        )
                        .company(tender.getCompany())
                        .transporter(
                                bid.getTransporter()
                        )
                        .finalAmount(finalAmount)
                        .terms(terms.trim())
                        .status(
                                ContractStatus.PENDING_ACCEPTANCE
                        )
                        .build();

        ContractEntity saved =
                contractRepository.save(contract);

        tender.setStatus(
                TenderStatus.AWARDED
        );

        tenderRepository.save(tender);

        tender.setStatus(
                TenderStatus.CONTRACT_PENDING
        );

        tenderRepository.save(tender);

        return ContractResponseDto.from(saved);
    }

    @Transactional
    public ContractResponseDto acceptContract(
            UUID contractId,
            AcceptContractRequestDto request
    ) {

        UUID transporterId = getCurrentUserId();

        if (request == null ||
                !request.accepted()) {

            throw new ResponseStatusException(
                    HttpStatus.BAD_REQUEST,
                    "Contract acceptance must be explicitly confirmed"
            );
        }

        ContractEntity contract =
                contractRepository.findById(
                                contractId
                        )
                        .orElseThrow(() ->
                                new ResponseStatusException(
                                        HttpStatus.NOT_FOUND,
                                        "Contract not found"
                                )
                        );

        if (!contract.getTransporter()
                .getId()
                .equals(transporterId)) {

            throw new ResponseStatusException(
                    HttpStatus.FORBIDDEN,
                    "Only the awarded transporter can accept this contract"
            );
        }

        if (contract.getStatus() !=
                ContractStatus.PENDING_ACCEPTANCE) {

            throw new ResponseStatusException(
                    HttpStatus.CONFLICT,
                    "Contract is no longer pending acceptance"
            );
        }

        TenderEntity tender =
                tenderRepository.findByIdForUpdate(
                                contract.getTenderId()
                        )
                        .orElseThrow(() ->
                                new ResponseStatusException(
                                        HttpStatus.NOT_FOUND,
                                        "Tender not found"
                                )
                        );

        if (tender.getStatus() !=
                TenderStatus.CONTRACT_PENDING) {

            throw new ResponseStatusException(
                    HttpStatus.CONFLICT,
                    "Tender is not waiting for contract acceptance"
            );
        }

        contract.setStatus(
                ContractStatus.ACCEPTED
        );

        contract.setAcceptedBy(
                transporterId
        );

        contract.setAcceptedAt(
                Instant.now()
        );

        ContractEntity saved =
                contractRepository.save(contract);

        /*
         * Phase 7:
         *
         * CONTRACT_ACCEPTED
         *        ↓
         * DeliveryEntity
         *        ↓
         * PENDING_PICKUP
         *
         * The delivery is created in the same transaction.
         */
        DeliveryEntity delivery =
                deliveryService
                        .provisionFromAcceptedContract(
                                saved
                        );

        if (delivery.getStatus() !=
                com.bidhaul.delivery.enums.DeliveryStatus.PENDING_PICKUP) {

            throw new ResponseStatusException(
                    HttpStatus.INTERNAL_SERVER_ERROR,
                    "Delivery was not provisioned in PENDING_PICKUP state"
            );
        }

        tender.setStatus(
                TenderStatus.CONTRACT_ACCEPTED
        );

        tenderRepository.save(tender);

        return ContractResponseDto.from(saved);
    }

    @Transactional(readOnly = true)
    public ContractResponseDto getContract(
            UUID contractId
    ) {

        UUID userId = getCurrentUserId();

        ContractEntity contract =
                contractRepository.findById(
                                contractId
                        )
                        .orElseThrow(() ->
                                new ResponseStatusException(
                                        HttpStatus.NOT_FOUND,
                                        "Contract not found"
                                )
                        );

        ensureParticipant(
                contract,
                userId
        );

        return ContractResponseDto.from(contract);
    }

    @Transactional(readOnly = true)
    public ContractResponseDto getTenderContract(
            UUID tenderId
    ) {

        UUID userId = getCurrentUserId();

        ContractEntity contract =
                contractRepository.findByTenderId(
                                tenderId
                        )
                        .orElseThrow(() ->
                                new ResponseStatusException(
                                        HttpStatus.NOT_FOUND,
                                        "Contract not found for tender"
                                )
                        );

        ensureParticipant(
                contract,
                userId
        );

        return ContractResponseDto.from(contract);
    }

    @Transactional(readOnly = true)
    public List<ContractResponseDto> getMyContracts() {

        UUID userId = getCurrentUserId();

        return contractRepository.findAll()
                .stream()
                .filter(contract ->
                        contract.getCompany()
                                .getId()
                                .equals(userId)
                                ||
                                contract.getTransporter()
                                        .getId()
                                        .equals(userId)
                )
                .map(ContractResponseDto::from)
                .toList();
    }

    private CompetitiveBidResponseDto toCompetitiveBid(
            BidEntity bid,
            int rank
    ) {

        Negotiation negotiation =
                negotiationRepository
                        .findByBidId(
                                bid.getId()
                        )
                        .orElse(null);

        BigDecimal currentAmount = null;
        BigDecimal finalAmount = null;
        NegotiationStatus negotiationStatus = null;

        if (negotiation != null) {

            negotiationStatus =
                    negotiation.getStatus();

            currentAmount =
                    negotiationOfferRepository
                            .findTopByNegotiationIdOrderByCreatedAtDesc(
                                    negotiation.getId()
                            )
                            .map(offer ->
                                    offer.getAmount()
                            )
                            .orElse(null);

            finalAmount =
                    negotiation.getFinalAmount();
        }

        BigDecimal comparisonAmount;

        if (finalAmount != null) {
            comparisonAmount = finalAmount;

        } else if (currentAmount != null) {
            comparisonAmount = currentAmount;

        } else {
            comparisonAmount = bid.getAmount();
        }

        BigDecimal savings =
                bid.getAmount()
                        .subtract(comparisonAmount)
                        .setScale(
                                2,
                                RoundingMode.HALF_UP
                        );

        return new CompetitiveBidResponseDto(
                rank,
                bid.getId(),
                bid.getBidNumber(),
                bid.getTransporter().getId(),
                bid.getTransporter().getFullName(),
                bid.getAmount(),
                currentAmount,
                finalAmount,
                savings,
                negotiationStatus
        );
    }

    private void ensureParticipant(
            ContractEntity contract,
            UUID userId
    ) {

        boolean company =
                contract.getCompany()
                        .getId()
                        .equals(userId);

        boolean transporter =
                contract.getTransporter()
                        .getId()
                        .equals(userId);

        if (!company && !transporter) {

            throw new ResponseStatusException(
                    HttpStatus.FORBIDDEN,
                    "You are not a participant in this contract"
            );
        }
    }

    private void ensureTenderOwner(
            TenderEntity tender,
            UUID userId
    ) {

        if (!tender.getCompany()
                .getId()
                .equals(userId)) {

            throw new ResponseStatusException(
                    HttpStatus.FORBIDDEN,
                    "You can only manage your own tender"
            );
        }
    }

    private TenderEntity findTender(
            UUID tenderId
    ) {

        return tenderRepository.findById(
                        tenderId
                )
                .orElseThrow(() ->
                        new ResponseStatusException(
                                HttpStatus.NOT_FOUND,
                                "Tender not found"
                        )
                );
    }

    private UUID getCurrentUserId() {

        return SecurityUtils.getCurrentUserId()
                .orElseThrow(() ->
                        new ResponseStatusException(
                                HttpStatus.UNAUTHORIZED,
                                "Authentication required"
                        )
                );
    }

    private String generateContractNumber() {

        String uuidPart =
                UUID.randomUUID()
                        .toString()
                        .replace("-", "")
                        .substring(
                                0,
                                10
                        )
                        .toUpperCase();

        return "CNT-" + uuidPart;
    }
}