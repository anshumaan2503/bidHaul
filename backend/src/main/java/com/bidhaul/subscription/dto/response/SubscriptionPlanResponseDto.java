package com.bidhaul.subscription.dto.response;

import com.bidhaul.subscription.entity.SubscriptionPlanEntity;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.UUID;

public record SubscriptionPlanResponseDto(

        UUID id,

        String name,

        BigDecimal monthlyPrice,

        String description,

        String features,

        boolean recommended,

        boolean active,

        Instant createdAt,

        Instant updatedAt

) {

    public static SubscriptionPlanResponseDto from(
            SubscriptionPlanEntity plan
    ) {

        return new SubscriptionPlanResponseDto(
                plan.getId(),
                plan.getName(),
                plan.getMonthlyPrice(),
                plan.getDescription(),
                plan.getFeatures(),
                plan.isRecommended(),
                plan.isActive(),
                plan.getCreatedAt(),
                plan.getUpdatedAt()
        );
    }
}