package com.bidhaul.delivery.entity;

import com.bidhaul.common.entity.BaseEntity;
import com.bidhaul.contract.entity.ContractEntity;
import com.bidhaul.delivery.enums.DeliveryStatus;
import com.bidhaul.user.entity.UserEntity;
import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.UUID;

@Entity
@Table(
        name = "deliveries",
        uniqueConstraints = {
                @UniqueConstraint(
                        name = "uk_deliveries_contract_id",
                        columnNames = "contract_id"
                )
        },
        indexes = {
                @Index(
                        name = "idx_deliveries_company_id",
                        columnList = "company_id"
                ),
                @Index(
                        name = "idx_deliveries_transporter_id",
                        columnList = "transporter_id"
                ),
                @Index(
                        name = "idx_deliveries_status",
                        columnList = "status"
                )
        }
)
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class DeliveryEntity extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @OneToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(
            name = "contract_id",
            nullable = false,
            unique = true,
            foreignKey = @ForeignKey(
                    name = "fk_deliveries_contract"
            )
    )
    private ContractEntity contract;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(
            name = "company_id",
            nullable = false,
            foreignKey = @ForeignKey(
                    name = "fk_deliveries_company"
            )
    )
    private UserEntity company;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(
            name = "transporter_id",
            nullable = false,
            foreignKey = @ForeignKey(
                    name = "fk_deliveries_transporter"
            )
    )
    private UserEntity transporter;

    @Column(
            name = "pickup_location",
            nullable = false,
            length = 255
    )
    private String pickupLocation;

    @Column(
            name = "delivery_location",
            nullable = false,
            length = 255
    )
    private String deliveryLocation;

    @Enumerated(EnumType.STRING)
    @Column(
            nullable = false,
            length = 30
    )
    @Builder.Default
    private DeliveryStatus status =
            DeliveryStatus.PENDING_PICKUP;

    @Column(name = "picked_up_at")
    private Instant pickedUpAt;

    @Column(name = "delivered_at")
    private Instant deliveredAt;

    @Column(name = "confirmed_at")
    private Instant confirmedAt;

    @Column(
            precision = 3,
            scale = 2
    )
    private BigDecimal rating;
}