package com.bidhaul.tender.service;

import com.bidhaul.bid.entity.BidEntity;
import com.bidhaul.bid.enums.BidStatus;
import com.bidhaul.bid.repository.BidRepository;
import com.bidhaul.contract.repository.ContractRepository;
import com.bidhaul.negotiation.entity.Negotiation;
import com.bidhaul.negotiation.repository.NegotiationRepository;
import com.bidhaul.security.util.SecurityUtils;
import com.bidhaul.tender.dto.request.CreateTenderRequestDto;
import com.bidhaul.tender.dto.response.TenderResponseDto;
import com.bidhaul.tender.entity.TenderEntity;
import com.bidhaul.tender.enums.TenderStatus;
import com.bidhaul.tender.repository.TenderRepository;
import com.bidhaul.user.entity.UserEntity;
import com.bidhaul.user.repository.UserRepository;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;
import java.util.UUID;
import java.util.concurrent.ThreadLocalRandom;

@Service
public class TenderService {

    private static final int TOP_QUALIFIED_BIDS = 5;

    @PersistenceContext
    private EntityManager entityManager;

    private final TenderRepository tenderRepository;
    private final UserRepository userRepository;
    private final BidRepository bidRepository;
    private final NegotiationRepository negotiationRepository;
    private final ContractRepository contractRepository;

    public TenderService(
            TenderRepository tenderRepository,
            UserRepository userRepository,
            BidRepository bidRepository,
            NegotiationRepository negotiationRepository,
            ContractRepository contractRepository
    ) {
        this.tenderRepository = tenderRepository;
        this.userRepository = userRepository;
        this.bidRepository = bidRepository;
        this.negotiationRepository = negotiationRepository;
        this.contractRepository = contractRepository;
    }

    @Transactional
    public TenderResponseDto createTender(
            CreateTenderRequestDto request
    ) {

        UUID userId = SecurityUtils.getCurrentUserId()
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.UNAUTHORIZED,
                        "Authentication required"
                ));

        UserEntity company = userRepository.findById(userId)
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.NOT_FOUND,
                        "Authenticated user not found"
                ));

        if (company.getUserType() == null ||
                !company.getUserType().name().equals("COMPANY")) {

            throw new ResponseStatusException(
                    HttpStatus.FORBIDDEN,
                    "Only company users can create tenders"
            );
        }

        TenderEntity tender = new TenderEntity();

        tender.setTenderNumber(generateTenderNumber());
        tender.setCompany(company);
        tender.setTitle(request.title().trim());
        tender.setDescription(request.description().trim());
        tender.setPickupLocation(request.pickupLocation().trim());
        tender.setDeliveryLocation(request.deliveryLocation().trim());
        tender.setMaterialType(request.materialType().trim());
        tender.setVehicleType(request.vehicleType().trim());
        tender.setWeightTons(request.weightTons());
        tender.setCeilingBudget(request.ceilingBudget());
        tender.setStatus(TenderStatus.LIVE);

        return TenderResponseDto.from(
                tenderRepository.save(tender)
        );
    }

    @Transactional(readOnly = true)
    public TenderResponseDto getTender(UUID tenderId) {

        return TenderResponseDto.from(
                findTender(tenderId)
        );
    }

    @Transactional(readOnly = true)
    public List<TenderResponseDto> getMyTenders() {

        UUID userId = SecurityUtils.getCurrentUserId()
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.UNAUTHORIZED,
                        "Authentication required"
                ));

        return tenderRepository
                .findByCompanyIdOrderByCreatedAtDesc(userId)
                .stream()
                .map(TenderResponseDto::from)
                .toList();
    }

    @Transactional(readOnly = true)
    public List<TenderResponseDto> getLiveTenders() {

        return tenderRepository
                .findByStatusOrderByCreatedAtDesc(TenderStatus.LIVE)
                .stream()
                .map(TenderResponseDto::from)
                .toList();
    }

    @Transactional
    public TenderResponseDto closeTender(UUID tenderId) {

        UUID userId = SecurityUtils.getCurrentUserId()
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.UNAUTHORIZED,
                        "Authentication required"
                ));

        TenderEntity tender =
                tenderRepository.findByIdForUpdate(tenderId)
                        .orElseThrow(() -> new ResponseStatusException(
                                HttpStatus.NOT_FOUND,
                                "Tender not found"
                        ));

        if (!tender.getCompany().getId().equals(userId)) {
            throw new ResponseStatusException(
                    HttpStatus.FORBIDDEN,
                    "You can only close your own tender"
            );
        }

        if (tender.getStatus() != TenderStatus.LIVE) {
            throw new ResponseStatusException(
                    HttpStatus.CONFLICT,
                    "Only live tenders can be closed"
            );
        }

        List<BidEntity> pendingBids =
                bidRepository
                        .findByTenderIdAndStatusOrderByAmountAscCreatedAtAsc(
                                tenderId,
                                BidStatus.PENDING
                        );

        for (int i = 0; i < pendingBids.size(); i++) {

            BidEntity bid = pendingBids.get(i);

            if (i < TOP_QUALIFIED_BIDS) {
                bid.setStatus(BidStatus.ACCEPTED);
            } else {
                bid.setStatus(BidStatus.REJECTED);
            }
        }

        if (!pendingBids.isEmpty()) {
            bidRepository.saveAll(pendingBids);
        }

        /*
         * COMPLETED means the reverse auction has closed and
         * the Top 5 have been qualified.
         *
         * Phase 6 begins from this state.
         */
        tender.setStatus(TenderStatus.COMPLETED);

        return TenderResponseDto.from(
                tenderRepository.save(tender)
        );
    }

    @Transactional
    public void deleteTender(UUID tenderId) {

        UUID userId = SecurityUtils.getCurrentUserId()
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.UNAUTHORIZED,
                        "Authentication required"
                ));

        TenderEntity tender = tenderRepository.findById(tenderId)
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.NOT_FOUND,
                        "Tender not found"
                ));

        if (!tender.getCompany().getId().equals(userId)) {
            throw new ResponseStatusException(
                    HttpStatus.FORBIDDEN,
                    "You can only delete your own tender"
            );
        }

        // Cascade delete all dependent records across all modules in strict reverse relational dependency order:
        // Contracts MUST be deleted before Negotiations & Bids because Contracts references both!

        // 1. Delete delivery tracking events
        entityManager.createNativeQuery(
                "DELETE FROM delivery_tracking_events WHERE delivery_id IN (" +
                "  SELECT d.id FROM deliveries d JOIN contracts c ON d.contract_id = c.id WHERE c.tender_id = :tenderId" +
                ")"
        ).setParameter("tenderId", tenderId).executeUpdate();

        // 2. Delete deliveries
        entityManager.createNativeQuery(
                "DELETE FROM deliveries WHERE contract_id IN (" +
                "  SELECT id FROM contracts WHERE tender_id = :tenderId" +
                ")"
        ).setParameter("tenderId", tenderId).executeUpdate();

        // 3. Delete contracts (frees fk_contracts_negotiation, fk_contracts_bid, and fk_contracts_tender)
        entityManager.createNativeQuery(
                "DELETE FROM contracts WHERE tender_id = :tenderId"
        ).setParameter("tenderId", tenderId).executeUpdate();

        // 4. Delete negotiation offers
        entityManager.createNativeQuery(
                "DELETE FROM negotiation_offers WHERE negotiation_id IN (" +
                "  SELECT id FROM negotiations WHERE tender_id = :tenderId" +
                ")"
        ).setParameter("tenderId", tenderId).executeUpdate();

        // 5. Delete negotiations (frees fk_negotiations_bid and fk_negotiations_tender)
        entityManager.createNativeQuery(
                "DELETE FROM negotiations WHERE tender_id = :tenderId"
        ).setParameter("tenderId", tenderId).executeUpdate();

        // 6. Delete bids (frees fk_bids_tender)
        entityManager.createNativeQuery(
                "DELETE FROM bids WHERE tender_id = :tenderId"
        ).setParameter("tenderId", tenderId).executeUpdate();

        // 7. Delete primary tender record
        entityManager.createNativeQuery(
                "DELETE FROM tenders WHERE id = :tenderId"
        ).setParameter("tenderId", tenderId).executeUpdate();
    }

    private TenderEntity findTender(UUID tenderId) {

        return tenderRepository.findById(tenderId)
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.NOT_FOUND,
                        "Tender not found"
                ));
    }

    private String generateTenderNumber() {

        return "TN-" +
                ThreadLocalRandom.current()
                        .nextInt(100000, 1000000);
    }
}