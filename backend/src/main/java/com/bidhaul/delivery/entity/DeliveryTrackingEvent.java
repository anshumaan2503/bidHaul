package com.bidhaul.delivery.entity;

import com.bidhaul.delivery.enums.DeliveryStatus;
import jakarta.persistence.*;
import lombok.*;

import java.time.Instant;
import java.util.UUID;

@Entity
@Table(
        name = "delivery_tracking_events",
        indexes = {
                @Index(
                        name = "idx_delivery_tracking_delivery_id",
                        columnList = "delivery_id"
                ),
                @Index(
                        name = "idx_delivery_tracking_created_at",
                        columnList = "created_at"
                )
        }
)
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class DeliveryTrackingEvent {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(
            name = "delivery_id",
            nullable = false,
            foreignKey = @ForeignKey(
                    name = "fk_tracking_delivery"
            )
    )
    private DeliveryEntity delivery;

    @Enumerated(EnumType.STRING)
    @Column(
            nullable = false,
            length = 30
    )
    private DeliveryStatus status;

    @Column(
            nullable = false,
            length = 255
    )
    private String location;

    @Column(
            columnDefinition = "TEXT"
    )
    private String remarks;

    @Column(
            name = "created_at",
            nullable = false,
            updatable = false
    )
    @Builder.Default
    private Instant createdAt = Instant.now();
}