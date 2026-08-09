package com.bidhaul.delivery.service;

import com.bidhaul.contract.entity.ContractEntity;
import com.bidhaul.contract.enums.ContractStatus;
import com.bidhaul.delivery.dto.request.AddTrackingUpdateRequestDto;
import com.bidhaul.delivery.dto.request.RateDeliveryRequestDto;
import com.bidhaul.delivery.dto.response.DeliveryResponseDto;
import com.bidhaul.delivery.dto.response.TrackingEventResponseDto;
import com.bidhaul.delivery.entity.DeliveryEntity;
import com.bidhaul.delivery.entity.DeliveryTrackingEvent;
import com.bidhaul.delivery.enums.DeliveryStatus;
import com.bidhaul.delivery.repository.DeliveryRepository;
import com.bidhaul.delivery.repository.DeliveryTrackingEventRepository;
import com.bidhaul.security.util.SecurityUtils;
import com.bidhaul.tender.entity.TenderEntity;
import com.bidhaul.tender.enums.TenderStatus;
import com.bidhaul.tender.repository.TenderRepository;
import com.bidhaul.transporter.entity.TransporterProfileEntity;
import com.bidhaul.transporter.repository.TransporterProfileRepository;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.Instant;
import java.util.List;
import java.util.UUID;

@Service
public class DeliveryService {

    private final DeliveryRepository deliveryRepository;
    private final DeliveryTrackingEventRepository trackingRepository;
    private final TenderRepository tenderRepository;
    private final TransporterProfileRepository transporterProfileRepository;

    public DeliveryService(
            DeliveryRepository deliveryRepository,
            DeliveryTrackingEventRepository trackingRepository,
            TenderRepository tenderRepository,
            TransporterProfileRepository transporterProfileRepository
    ) {
        this.deliveryRepository = deliveryRepository;
        this.trackingRepository = trackingRepository;
        this.tenderRepository = tenderRepository;
        this.transporterProfileRepository =
                transporterProfileRepository;
    }

    /**
     * Creates the delivery automatically after a contract
     * has been accepted by the winning transporter.
     *
     * This method receives the already-loaded ContractEntity
     * so there is no dependency from DeliveryService back to
     * ContractService.
     */
    @Transactional
    public DeliveryEntity provisionFromAcceptedContract(
            ContractEntity contract
    ) {

        if (contract.getStatus() != ContractStatus.ACCEPTED) {
            throw new ResponseStatusException(
                    HttpStatus.CONFLICT,
                    "Delivery can only be created from an accepted contract"
            );
        }

        if (deliveryRepository.existsByContractId(
                contract.getId()
        )) {
            throw new ResponseStatusException(
                    HttpStatus.CONFLICT,
                    "A delivery already exists for this contract"
            );
        }

        TenderEntity tender =
                tenderRepository.findById(
                                contract.getTenderId()
                        )
                        .orElseThrow(() ->
                                new ResponseStatusException(
                                        HttpStatus.NOT_FOUND,
                                        "Tender not found for contract"
                                )
                        );

        DeliveryEntity delivery =
                DeliveryEntity.builder()
                        .contract(contract)
                        .company(contract.getCompany())
                        .transporter(contract.getTransporter())
                        .pickupLocation(
                                tender.getPickupLocation()
                        )
                        .deliveryLocation(
                                tender.getDeliveryLocation()
                        )
                        .status(
                                DeliveryStatus.PENDING_PICKUP
                        )
                        .build();

        DeliveryEntity saved =
                deliveryRepository.save(delivery);

        createTrackingEvent(
                saved,
                DeliveryStatus.PENDING_PICKUP,
                tender.getPickupLocation(),
                "Delivery created and awaiting pickup"
        );

        return saved;
    }

    @Transactional(readOnly = true)
    public DeliveryResponseDto getDelivery(
            UUID deliveryId
    ) {

        UUID userId = getCurrentUserId();

        DeliveryEntity delivery =
                findDelivery(deliveryId);

        ensureParticipant(
                delivery,
                userId
        );

        return DeliveryResponseDto.from(delivery);
    }

    @Transactional(readOnly = true)
    public DeliveryResponseDto getContractDelivery(
            UUID contractId
    ) {

        UUID userId = getCurrentUserId();

        DeliveryEntity delivery =
                deliveryRepository.findByContractId(
                                contractId
                        )
                        .orElseThrow(() ->
                                new ResponseStatusException(
                                        HttpStatus.NOT_FOUND,
                                        "Delivery not found for contract"
                                )
                        );

        ensureParticipant(
                delivery,
                userId
        );

        return DeliveryResponseDto.from(delivery);
    }

    @Transactional(readOnly = true)
    public List<DeliveryResponseDto> getMyDeliveries() {

        UUID userId = getCurrentUserId();

        List<DeliveryEntity> deliveries =
                deliveryRepository
                        .findByCompanyIdOrderByCreatedAtDesc(
                                userId
                        );

        if (deliveries.isEmpty()) {

            deliveries =
                    deliveryRepository
                            .findByTransporterIdOrderByCreatedAtDesc(
                                    userId
                            );
        }

        return deliveries.stream()
                .map(DeliveryResponseDto::from)
                .toList();
    }

    @Transactional(readOnly = true)
    public List<TrackingEventResponseDto> getTrackingHistory(
            UUID deliveryId
    ) {

        UUID userId = getCurrentUserId();

        DeliveryEntity delivery =
                findDelivery(deliveryId);

        ensureParticipant(
                delivery,
                userId
        );

        return trackingRepository
                .findByDeliveryIdOrderByCreatedAtAsc(
                        deliveryId
                )
                .stream()
                .map(TrackingEventResponseDto::from)
                .toList();
    }

    /**
     * Transporter starts the physical delivery.
     *
     * PENDING_PICKUP -> IN_TRANSIT
     */
    @Transactional
    public DeliveryResponseDto markPickedUp(
            UUID deliveryId,
            AddTrackingUpdateRequestDto request
    ) {

        UUID transporterId = getCurrentUserId();

        DeliveryEntity delivery =
                findDelivery(deliveryId);

        ensureTransporter(
                delivery,
                transporterId
        );

        if (delivery.getStatus() !=
                DeliveryStatus.PENDING_PICKUP) {

            throw new ResponseStatusException(
                    HttpStatus.CONFLICT,
                    "Delivery is not waiting for pickup"
            );
        }

        Instant now = Instant.now();

        delivery.setStatus(
                DeliveryStatus.IN_TRANSIT
        );

        delivery.setPickedUpAt(now);

        DeliveryEntity saved =
                deliveryRepository.save(delivery);

        createTrackingEvent(
                saved,
                DeliveryStatus.IN_TRANSIT,
                request.getLocation(),
                request.getRemarks() != null
                        ? request.getRemarks().trim()
                        : "Shipment picked up and is now in transit"
        );

        updateTenderStatus(
                delivery.getContract().getTenderId(),
                TenderStatus.IN_TRANSIT
        );

        return DeliveryResponseDto.from(saved);
    }

    /**
     * Transporter marks the shipment as delivered.
     *
     * IN_TRANSIT -> DELIVERED
     */
    @Transactional
    public DeliveryResponseDto markDelivered(
            UUID deliveryId,
            AddTrackingUpdateRequestDto request
    ) {

        UUID transporterId = getCurrentUserId();

        DeliveryEntity delivery =
                findDelivery(deliveryId);

        ensureTransporter(
                delivery,
                transporterId
        );

        if (delivery.getStatus() !=
                DeliveryStatus.IN_TRANSIT) {

            throw new ResponseStatusException(
                    HttpStatus.CONFLICT,
                    "Only in-transit deliveries can be marked as delivered"
            );
        }

        Instant now = Instant.now();

        delivery.setStatus(
                DeliveryStatus.DELIVERED
        );

        delivery.setDeliveredAt(now);

        DeliveryEntity saved =
                deliveryRepository.save(delivery);

        createTrackingEvent(
                saved,
                DeliveryStatus.DELIVERED,
                request.getLocation(),
                request.getRemarks() != null
                        ? request.getRemarks().trim()
                        : "Shipment delivered and awaiting company confirmation"
        );

        return DeliveryResponseDto.from(saved);
    }

    /**
     * Adds a tracking event while a delivery is active.
     *
     * This does not change the delivery lifecycle state.
     */
    @Transactional
    public TrackingEventResponseDto addTrackingUpdate(
            UUID deliveryId,
            AddTrackingUpdateRequestDto request
    ) {

        UUID transporterId = getCurrentUserId();

        DeliveryEntity delivery =
                findDelivery(deliveryId);

        ensureTransporter(
                delivery,
                transporterId
        );

        if (delivery.getStatus() !=
                DeliveryStatus.PENDING_PICKUP
                && delivery.getStatus() !=
                DeliveryStatus.IN_TRANSIT) {

            throw new ResponseStatusException(
                    HttpStatus.CONFLICT,
                    "Tracking updates are only allowed for active deliveries"
            );
        }

        DeliveryTrackingEvent event =
                createTrackingEvent(
                        delivery,
                        delivery.getStatus(),
                        request.getLocation(),
                        request.getRemarks()
                );

        return TrackingEventResponseDto.from(event);
    }

    /**
     * Company confirms delivery and rates the transporter.
     *
     * DELIVERED -> COMPLETED
     */
    @Transactional
    public DeliveryResponseDto confirmDelivery(
            UUID deliveryId,
            RateDeliveryRequestDto request
    ) {

        UUID companyId = getCurrentUserId();

        DeliveryEntity delivery =
                findDelivery(deliveryId);

        ensureCompany(
                delivery,
                companyId
        );

        if (delivery.getStatus() !=
                DeliveryStatus.DELIVERED) {

            throw new ResponseStatusException(
                    HttpStatus.CONFLICT,
                    "Only delivered shipments can be confirmed"
            );
        }

        BigDecimal rating =
                request.getRating()
                        .setScale(
                                2,
                                RoundingMode.HALF_UP
                        );

        Instant now = Instant.now();

        delivery.setStatus(
                DeliveryStatus.COMPLETED
        );

        delivery.setConfirmedAt(now);
        delivery.setRating(rating);

        DeliveryEntity saved =
                deliveryRepository.save(delivery);

        updateTransporterRating(
                delivery.getTransporter().getId(),
                rating
        );

        createTrackingEvent(
                saved,
                DeliveryStatus.COMPLETED,
                delivery.getDeliveryLocation(),
                "Company confirmed delivery"
        );

        updateTenderStatus(
                delivery.getContract().getTenderId(),
                TenderStatus.COMPLETED_DELIVERY
        );

        return DeliveryResponseDto.from(saved);
    }

    private void updateTransporterRating(
            UUID transporterUserId,
            BigDecimal newRating
    ) {

        TransporterProfileEntity profile =
                transporterProfileRepository
                        .findByUserId(
                                transporterUserId
                        )
                        .orElseThrow(() ->
                                new ResponseStatusException(
                                        HttpStatus.NOT_FOUND,
                                        "Transporter profile not found"
                                )
                        );

        int previousCompleted =
                profile.getCompletedDeliveries() == null
                        ? 0
                        : profile.getCompletedDeliveries();

        BigDecimal previousRating =
                profile.getRating();

        BigDecimal updatedRating;

        if (previousCompleted <= 0 ||
                previousRating == null) {

            updatedRating = newRating;

        } else {

            BigDecimal previousTotal =
                    previousRating.multiply(
                            BigDecimal.valueOf(
                                    previousCompleted
                            )
                    );

            updatedRating =
                    previousTotal
                            .add(newRating)
                            .divide(
                                    BigDecimal.valueOf(
                                            previousCompleted + 1
                                    ),
                                    2,
                                    RoundingMode.HALF_UP
                            );
        }

        profile.setRating(
                updatedRating.setScale(
                        2,
                        RoundingMode.HALF_UP
                )
        );

        profile.setCompletedDeliveries(
                previousCompleted + 1
        );

        transporterProfileRepository.save(profile);
    }

    private DeliveryTrackingEvent createTrackingEvent(
            DeliveryEntity delivery,
            DeliveryStatus status,
            String location,
            String remarks
    ) {

        if (location == null ||
                location.isBlank()) {

            throw new ResponseStatusException(
                    HttpStatus.BAD_REQUEST,
                    "Tracking location is required"
            );
        }

        DeliveryTrackingEvent event =
                DeliveryTrackingEvent.builder()
                        .delivery(delivery)
                        .status(status)
                        .location(location.trim())
                        .remarks(
                                remarks == null
                                        ? null
                                        : remarks.trim()
                        )
                        .createdAt(Instant.now())
                        .build();

        return trackingRepository.save(event);
    }

    private void updateTenderStatus(
            UUID tenderId,
            TenderStatus status
    ) {

        TenderEntity tender =
                tenderRepository.findByIdForUpdate(
                                tenderId
                        )
                        .orElseThrow(() ->
                                new ResponseStatusException(
                                        HttpStatus.NOT_FOUND,
                                        "Tender not found"
                                )
                        );

        tender.setStatus(status);

        tenderRepository.save(tender);
    }

    private DeliveryEntity findDelivery(
            UUID deliveryId
    ) {

        return deliveryRepository.findById(
                        deliveryId
                )
                .orElseThrow(() ->
                        new ResponseStatusException(
                                HttpStatus.NOT_FOUND,
                                "Delivery not found"
                        )
                );
    }

    private void ensureParticipant(
            DeliveryEntity delivery,
            UUID userId
    ) {

        boolean company =
                delivery.getCompany()
                        .getId()
                        .equals(userId);

        boolean transporter =
                delivery.getTransporter()
                        .getId()
                        .equals(userId);

        if (!company && !transporter) {

            throw new ResponseStatusException(
                    HttpStatus.FORBIDDEN,
                    "You are not a participant in this delivery"
            );
        }
    }

    private void ensureTransporter(
            DeliveryEntity delivery,
            UUID userId
    ) {

        if (!delivery.getTransporter()
                .getId()
                .equals(userId)) {

            throw new ResponseStatusException(
                    HttpStatus.FORBIDDEN,
                    "Only the assigned transporter can perform this action"
            );
        }
    }

    private void ensureCompany(
            DeliveryEntity delivery,
            UUID userId
    ) {

        if (!delivery.getCompany()
                .getId()
                .equals(userId)) {

            throw new ResponseStatusException(
                    HttpStatus.FORBIDDEN,
                    "Only the owning company can perform this action"
            );
        }
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
}