package com.bidhaul.bid.dto.response;

import com.bidhaul.bid.entity.BidEntity;
import com.bidhaul.bid.enums.BidStatus;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.UUID;

public record BidResponseDto(
        UUID id,
        String bidNumber,
        UUID tenderId,
        String transporterName,
        BigDecimal amount,
        Integer estimatedDays,
        String remarks,
        BidStatus status,
        Instant createdAt
) {

    public static BidResponseDto from(BidEntity bid) {

        return new BidResponseDto(
                bid.getId(),
                bid.getBidNumber(),
                bid.getTender().getId(),
                bid.getTransporter().getFullName(),
                bid.getAmount(),
                bid.getEstimatedDays(),
                bid.getRemarks(),
                bid.getStatus(),
                bid.getCreatedAt()
        );
    }
}