package com.bidhaul.company.dto.response;

import com.bidhaul.common.enums.KycStatus;
import lombok.*;

import java.time.Instant;
import java.util.UUID;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CompanyProfileResponseDto {

    private UUID id;
    private UUID userId;
    private String companyName;
    private String ownerName;
    private String email;
    private String phone;
    private String address;
    private String gstNumber;
    private String licenseNumber;
    private KycStatus verificationStatus;
    private String rejectionReason;
    private Instant submittedAt;
    private Instant verifiedAt;
    private Instant createdAt;
}
