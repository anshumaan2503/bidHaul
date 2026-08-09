package com.bidhaul.subscription.entity;

import com.bidhaul.common.entity.BaseEntity;
import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.util.UUID;

@Entity
@Table(
        name = "subscription_plans",
        uniqueConstraints = {
                @UniqueConstraint(
                        name = "uk_subscription_plans_name",
                        columnNames = "name"
                )
        },
        indexes = {
                @Index(
                        name = "idx_subscription_plans_active",
                        columnList = "is_active"
                )
        }
)
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class SubscriptionPlanEntity extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(
            nullable = false,
            unique = true,
            length = 100
    )
    private String name;

    @Column(
            name = "monthly_price",
            nullable = false,
            precision = 12,
            scale = 2
    )
    private BigDecimal monthlyPrice;

    @Column(
            nullable = false,
            columnDefinition = "TEXT"
    )
    private String description;

    /**
     * Stored as JSON text so the backend remains database-portable
     * without introducing an additional feature table.
     *
     * Example:
     * ["Tender Management","Reverse Bidding","Advanced Analytics"]
     */
    @Column(
            nullable = false,
            columnDefinition = "TEXT"
    )
    private String features;

    @Column(
            nullable = false,
            name = "recommended"
    )
    @Builder.Default
    private boolean recommended = false;

    @Column(
            name = "is_active",
            nullable = false
    )
    @Builder.Default
    private boolean active = true;
}