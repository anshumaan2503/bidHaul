package com.bidhaul.negotiation.entity;

import com.bidhaul.negotiation.enums.NegotiationStatus;
import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.UUID;

@Entity
@Table(
        name = "negotiations",
        uniqueConstraints = {
                @UniqueConstraint(
                        name = "uq_negotiation_bid",
                        columnNames = "bid_id"
                )
        },
        indexes = {
                @Index(
                        name = "idx_negotiations_tender_id",
                        columnList = "tender_id"
                ),
                @Index(
                        name = "idx_negotiations_company_id",
                        columnList = "company_id"
                ),
                @Index(
                        name = "idx_negotiations_transporter_id",
                        columnList = "transporter_id"
                )
        }
)
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Negotiation {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(name = "tender_id", nullable = false)
    private UUID tenderId;

    @Column(name = "bid_id", nullable = false)
    private UUID bidId;

    @Column(name = "company_id", nullable = false)
    private UUID companyId;

    @Column(name = "transporter_id", nullable = false)
    private UUID transporterId;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    @Builder.Default
    private NegotiationStatus status = NegotiationStatus.OPEN;

    @Column(name = "final_amount", precision = 12, scale = 2)
    private BigDecimal finalAmount;

    @Column(name = "accepted_by")
    private UUID acceptedBy;

    @Column(name = "closed_at")
    private Instant closedAt;

    @Column(name = "created_at", nullable = false, updatable = false)
    @Builder.Default
    private Instant createdAt = Instant.now();

    @Column(name = "updated_at", nullable = false)
    @Builder.Default
    private Instant updatedAt = Instant.now();

    @PreUpdate
    protected void onUpdate() {
        updatedAt = Instant.now();
    }
}