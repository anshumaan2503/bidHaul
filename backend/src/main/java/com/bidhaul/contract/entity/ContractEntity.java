package com.bidhaul.contract.entity;

import com.bidhaul.common.entity.BaseEntity;
import com.bidhaul.contract.enums.ContractStatus;
import com.bidhaul.user.entity.UserEntity;
import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.UUID;

@Entity
@Table(
        name = "contracts",
        uniqueConstraints = {
                @UniqueConstraint(
                        name = "uk_contracts_contract_number",
                        columnNames = "contract_number"
                ),
                @UniqueConstraint(
                        name = "uk_contracts_tender_id",
                        columnNames = "tender_id"
                ),
                @UniqueConstraint(
                        name = "uk_contracts_negotiation_id",
                        columnNames = "negotiation_id"
                )
        }
)
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ContractEntity extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(
            name = "contract_number",
            nullable = false,
            unique = true,
            length = 30
    )
    private String contractNumber;

    @Column(name = "tender_id", nullable = false)
    private UUID tenderId;

    @Column(name = "bid_id", nullable = false)
    private UUID bidId;

    @Column(name = "negotiation_id", nullable = false)
    private UUID negotiationId;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(
            name = "company_id",
            nullable = false,
            foreignKey = @ForeignKey(name = "fk_contracts_company")
    )
    private UserEntity company;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(
            name = "transporter_id",
            nullable = false,
            foreignKey = @ForeignKey(name = "fk_contracts_transporter")
    )
    private UserEntity transporter;

    @Column(
            name = "final_amount",
            nullable = false,
            precision = 12,
            scale = 2
    )
    private BigDecimal finalAmount;

    @Column(
            name = "terms",
            nullable = false,
            columnDefinition = "TEXT"
    )
    private String terms;

    @Enumerated(EnumType.STRING)
    @Column(
            nullable = false,
            length = 30
    )
    @Builder.Default
    private ContractStatus status =
            ContractStatus.PENDING_ACCEPTANCE;

    @Column(name = "accepted_by")
    private UUID acceptedBy;

    @Column(name = "accepted_at")
    private Instant acceptedAt;
}