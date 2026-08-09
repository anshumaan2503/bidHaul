package com.bidhaul.transporter.dto.response;

import com.bidhaul.common.enums.KycStatus;
import lombok.*;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.UUID;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class TransporterProfileResponseDto {

    private UUID id;
    private UUID userId;
    private String companyName;
    private String ownerName;
    private String email;
    private String phone;
    private String vehicleType;
    private Integer fleetSize;
    private String licenseNumber;
    private Integer completedDeliveries;
    private BigDecimal rating;
    private KycStatus verificationStatus;
    private String rejectionReason;
    private Instant submittedAt;
    private Instant verifiedAt;
    private Instant createdAt;
}
