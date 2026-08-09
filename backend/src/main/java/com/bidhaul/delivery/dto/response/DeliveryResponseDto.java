package com.bidhaul.delivery.dto.response;

import com.bidhaul.delivery.entity.DeliveryEntity;
import com.bidhaul.delivery.enums.DeliveryStatus;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.UUID;

public record DeliveryResponseDto(

        UUID id,

        UUID contractId,

        UUID tenderId,

        UUID companyId,

        UUID transporterId,

        String pickupLocation,

        String deliveryLocation,

        DeliveryStatus status,

        Instant pickedUpAt,

        Instant deliveredAt,

        Instant confirmedAt,

        BigDecimal rating,

        Instant createdAt,

        Instant updatedAt

) {

    public static DeliveryResponseDto from(
            DeliveryEntity delivery
    ) {

        return new DeliveryResponseDto(
                delivery.getId(),
                delivery.getContract().getId(),
                delivery.getContract().getTenderId(),
                delivery.getCompany().getId(),
                delivery.getTransporter().getId(),
                delivery.getPickupLocation(),
                delivery.getDeliveryLocation(),
                delivery.getStatus(),
                delivery.getPickedUpAt(),
                delivery.getDeliveredAt(),
                delivery.getConfirmedAt(),
                delivery.getRating(),
                delivery.getCreatedAt(),
                delivery.getUpdatedAt()
        );
    }
}