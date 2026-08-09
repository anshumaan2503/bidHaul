package com.bidhaul.tender.entity;

import com.bidhaul.common.entity.BaseEntity;
import com.bidhaul.tender.enums.TenderStatus;
import com.bidhaul.user.entity.UserEntity;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.util.UUID;

@Entity
@Table(
        name = "tenders",
        uniqueConstraints = {
                @UniqueConstraint(
                        name = "uk_tenders_tender_number",
                        columnNames = "tender_number"
                )
        }
)
@Getter
@Setter
@NoArgsConstructor
public class TenderEntity extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(name = "tender_number", nullable = false, unique = true, length = 30)
    private String tenderNumber;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(
            name = "company_id",
            nullable = false,
            foreignKey = @ForeignKey(name = "fk_tenders_company")
    )
    private UserEntity company;

    @Column(nullable = false, length = 255)
    private String title;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String description;

    @Column(name = "pickup_location", nullable = false, length = 255)
    private String pickupLocation;

    @Column(name = "delivery_location", nullable = false, length = 255)
    private String deliveryLocation;

    @Column(name = "material_type", nullable = false, length = 150)
    private String materialType;

    @Column(name = "vehicle_type", nullable = false, length = 150)
    private String vehicleType;

    @Column(name = "weight_tons", nullable = false, precision = 12, scale = 2)
    private BigDecimal weightTons;

    @Column(name = "ceiling_budget", nullable = false, precision = 12, scale = 2)
    private BigDecimal ceilingBudget;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 30)
    private TenderStatus status;
}