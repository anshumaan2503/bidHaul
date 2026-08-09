package com.bidhaul.transporter.entity;

import com.bidhaul.common.entity.BaseEntity;
import com.bidhaul.common.enums.KycStatus;
import com.bidhaul.user.entity.UserEntity;
import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.UUID;

@Entity
@Table(name = "transporter_profiles")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class TransporterProfileEntity extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @OneToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "user_id", nullable = false, unique = true)
    private UserEntity user;

    @Column(name = "company_name", nullable = false)
    private String companyName;

    @Column(name = "vehicle_type", nullable = false)
    private String vehicleType;

    @Column(name = "fleet_size", nullable = false)
    @Builder.Default
    private Integer fleetSize = 0;

    @Column(name = "license_number", unique = true)
    private String licenseNumber;

    @Column(name = "completed_deliveries", nullable = false)
    @Builder.Default
    private Integer completedDeliveries = 0;

    @Column(name = "rating", precision = 3, scale = 2)
    private BigDecimal rating;

    @Enumerated(EnumType.STRING)
    @Column(name = "verification_status", nullable = false)
    @Builder.Default
    private KycStatus verificationStatus = KycStatus.PENDING;

    @Column(name = "rejection_reason")
    private String rejectionReason;

    @Column(name = "submitted_at")
    private Instant submittedAt;

    @Column(name = "verified_at")
    private Instant verifiedAt;
}
