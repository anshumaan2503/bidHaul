package com.bidhaul.tender.dto.response;

import com.bidhaul.tender.entity.TenderEntity;
import com.bidhaul.tender.enums.TenderStatus;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.UUID;

public record TenderResponseDto(
        UUID id,
        String tenderNumber,
        String title,
        String description,
        String pickupLocation,
        String deliveryLocation,
        String materialType,
        String vehicleType,
        BigDecimal weightTons,
        BigDecimal ceilingBudget,
        TenderStatus status,
        Instant createdAt,
        Instant updatedAt
) {

    public static TenderResponseDto from(TenderEntity tender) {
        return new TenderResponseDto(
                tender.getId(),
                tender.getTenderNumber(),
                tender.getTitle(),
                tender.getDescription(),
                tender.getPickupLocation(),
                tender.getDeliveryLocation(),
                tender.getMaterialType(),
                tender.getVehicleType(),
                tender.getWeightTons(),
                tender.getCeilingBudget(),
                tender.getStatus(),
                tender.getCreatedAt(),
                tender.getUpdatedAt()
        );
    }
}