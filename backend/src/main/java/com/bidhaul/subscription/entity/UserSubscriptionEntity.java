package com.bidhaul.subscription.entity;

import com.bidhaul.common.entity.BaseEntity;
import com.bidhaul.subscription.enums.BillingCycle;
import com.bidhaul.subscription.enums.SubscriptionStatus;
import com.bidhaul.user.entity.UserEntity;
import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.UUID;

@Entity
@Table(
        name = "user_subscriptions",
        indexes = {
                @Index(
                        name = "idx_user_subscriptions_user_id",
                        columnList = "user_id"
                ),
                @Index(
                        name = "idx_user_subscriptions_status",
                        columnList = "status"
                ),
                @Index(
                        name = "idx_user_subscriptions_expiry",
                        columnList = "expires_at"
                )
        }
)
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UserSubscriptionEntity extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(
            name = "user_id",
            nullable = false,
            foreignKey = @ForeignKey(
                    name = "fk_user_subscriptions_user"
            )
    )
    private UserEntity user;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(
            name = "plan_id",
            nullable = false,
            foreignKey = @ForeignKey(
                    name = "fk_user_subscriptions_plan"
            )
    )
    private SubscriptionPlanEntity plan;

    @Enumerated(EnumType.STRING)
    @Column(
            name = "billing_cycle",
            nullable = false,
            length = 20
    )
    private BillingCycle billingCycle;

    @Enumerated(EnumType.STRING)
    @Column(
            nullable = false,
            length = 30
    )
    @Builder.Default
    private SubscriptionStatus status =
            SubscriptionStatus.PENDING_PAYMENT;

    /**
     * Snapshot of the plan price at subscription creation.
     * This prevents later plan-price changes from altering
     * historical subscription values.
     */
    @Column(
            name = "price_at_subscription",
            nullable = false,
            precision = 12,
            scale = 2
    )
    private BigDecimal priceAtSubscription;

    @Column(
            name = "starts_at"
    )
    private Instant startsAt;

    @Column(
            name = "expires_at"
    )
    private Instant expiresAt;
}