package com.bidhaul.subscription.dto.response;

import com.bidhaul.subscription.entity.UserSubscriptionEntity;
import com.bidhaul.subscription.enums.BillingCycle;
import com.bidhaul.subscription.enums.SubscriptionStatus;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.UUID;

public record UserSubscriptionResponseDto(

        UUID id,

        UUID userId,

        UUID planId,

        String planName,

        BigDecimal monthlyPrice,

        BigDecimal priceAtSubscription,

        String description,

        String features,

        BillingCycle billingCycle,

        SubscriptionStatus status,

        Instant startDate,

        Instant expiryDate,

        long remainingDays,

        Instant createdAt,

        Instant updatedAt

) {

    public static UserSubscriptionResponseDto from(
            UserSubscriptionEntity subscription
    ) {

        long remainingDays = 0;

        if (subscription.getExpiresAt() != null) {

            Instant now = Instant.now();

            if (subscription.getExpiresAt().isAfter(now)) {
                remainingDays =
                        ChronoUnit.DAYS.between(
                                now,
                                subscription.getExpiresAt()
                        );
            }
        }

        return new UserSubscriptionResponseDto(
                subscription.getId(),
                subscription.getUser().getId(),
                subscription.getPlan().getId(),
                subscription.getPlan().getName(),
                subscription.getPlan().getMonthlyPrice(),
                subscription.getPriceAtSubscription(),
                subscription.getPlan().getDescription(),
                subscription.getPlan().getFeatures(),
                subscription.getBillingCycle(),
                subscription.getStatus(),
                subscription.getStartsAt(),
                subscription.getExpiresAt(),
                remainingDays,
                subscription.getCreatedAt(),
                subscription.getUpdatedAt()
        );
    }
}