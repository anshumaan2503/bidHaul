package com.bidhaul.bid.entity;

import com.bidhaul.bid.enums.BidStatus;
import com.bidhaul.common.entity.BaseEntity;
import com.bidhaul.tender.entity.TenderEntity;
import com.bidhaul.user.entity.UserEntity;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.util.UUID;

@Entity
@Table(
        name = "bids",
        uniqueConstraints = {
                @UniqueConstraint(
                        name = "uk_bids_bid_number",
                        columnNames = "bid_number"
                )
        }
)
@Getter
@Setter
@NoArgsConstructor
public class BidEntity extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(
            name = "bid_number",
            nullable = false,
            unique = true,
            length = 30
    )
    private String bidNumber;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(
            name = "tender_id",
            nullable = false,
            foreignKey = @ForeignKey(name = "fk_bids_tender")
    )
    private TenderEntity tender;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(
            name = "transporter_id",
            nullable = false,
            foreignKey = @ForeignKey(name = "fk_bids_transporter")
    )
    private UserEntity transporter;

    @Column(
            nullable = false,
            precision = 12,
            scale = 2
    )
    private BigDecimal amount;

    @Column(
            name = "estimated_days",
            nullable = false
    )
    private Integer estimatedDays;

    @Column(
            nullable = false,
            columnDefinition = "TEXT"
    )
    private String remarks;

    @Enumerated(EnumType.STRING)
    @Column(
            nullable = false,
            length = 30
    )
    private BidStatus status;
}