package com.bidhaul.admin.service;

import com.bidhaul.admin.dto.request.KycRejectionRequestDto;
import com.bidhaul.audit.annotation.AuditLog;
import com.bidhaul.common.enums.KycStatus;
import com.bidhaul.common.exception.ResourceNotFoundException;
import com.bidhaul.company.dto.response.CompanyProfileResponseDto;
import com.bidhaul.company.entity.CompanyProfileEntity;
import com.bidhaul.company.repository.CompanyProfileRepository;
import com.bidhaul.transporter.dto.response.TransporterProfileResponseDto;
import com.bidhaul.transporter.entity.TransporterProfileEntity;
import com.bidhaul.transporter.repository.TransporterProfileRepository;
import com.bidhaul.user.entity.UserEntity;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class AdminKycService {

    private final CompanyProfileRepository companyProfileRepository;

    private final TransporterProfileRepository transporterProfileRepository;

    @Transactional(readOnly = true)
    public List<CompanyProfileResponseDto>
    getCompanyKycApplications(
            KycStatus status
    ) {

        List<CompanyProfileEntity> profiles;

        if (status == null) {

            profiles =
                    companyProfileRepository.findAll();

        } else {

            profiles =
                    companyProfileRepository
                            .findByVerificationStatusOrderBySubmittedAtAsc(
                                    status
                            );
        }

        return profiles.stream()
                .map(this::mapCompanyToResponse)
                .toList();
    }

    @Transactional(readOnly = true)
    public CompanyProfileResponseDto
    getCompanyKycApplication(
            UUID profileId
    ) {

        CompanyProfileEntity profile =
                companyProfileRepository
                        .findById(profileId)
                        .orElseThrow(() ->
                                new ResourceNotFoundException(
                                        "Company profile not found: "
                                                + profileId
                                )
                        );

        return mapCompanyToResponse(
                profile
        );
    }

    @Transactional
    @AuditLog(
            action = "KYC_COMPANY_APPROVED",
            entityType = "COMPANY_PROFILE"
    )
    public CompanyProfileResponseDto
    approveCompanyKyc(
            UUID profileId
    ) {

        CompanyProfileEntity profile =
                companyProfileRepository
                        .findById(profileId)
                        .orElseThrow(() ->
                                new ResourceNotFoundException(
                                        "Company profile not found: "
                                                + profileId
                                )
                        );

        validateSubmittedStatus(
                profile.getVerificationStatus()
        );

        profile.setVerificationStatus(
                KycStatus.VERIFIED
        );

        profile.setVerifiedAt(
                Instant.now()
        );

        profile.setRejectionReason(
                null
        );

        CompanyProfileEntity saved =
                companyProfileRepository.save(
                        profile
                );

        return mapCompanyToResponse(
                saved
        );
    }

    @Transactional
    @AuditLog(
            action = "KYC_COMPANY_REJECTED",
            entityType = "COMPANY_PROFILE"
    )
    public CompanyProfileResponseDto
    rejectCompanyKyc(
            UUID profileId,
            KycRejectionRequestDto request
    ) {

        CompanyProfileEntity profile =
                companyProfileRepository
                        .findById(profileId)
                        .orElseThrow(() ->
                                new ResourceNotFoundException(
                                        "Company profile not found: "
                                                + profileId
                                )
                        );

        validateSubmittedStatus(
                profile.getVerificationStatus()
        );

        String reason =
                request.getRejectionReason()
                        .trim();

        if (reason.isBlank()) {

            throw new IllegalArgumentException(
                    "Rejection reason is required"
            );
        }

        profile.setVerificationStatus(
                KycStatus.REJECTED
        );

        profile.setRejectionReason(
                reason
        );

        profile.setVerifiedAt(
                null
        );

        CompanyProfileEntity saved =
                companyProfileRepository.save(
                        profile
                );

        return mapCompanyToResponse(
                saved
        );
    }

    @Transactional(readOnly = true)
    public List<TransporterProfileResponseDto>
    getTransporterKycApplications(
            KycStatus status
    ) {

        List<TransporterProfileEntity> profiles;

        if (status == null) {

            profiles =
                    transporterProfileRepository.findAll();

        } else {

            profiles =
                    transporterProfileRepository
                            .findByVerificationStatusOrderBySubmittedAtAsc(
                                    status
                            );
        }

        return profiles.stream()
                .map(this::mapTransporterToResponse)
                .toList();
    }

    @Transactional(readOnly = true)
    public TransporterProfileResponseDto
    getTransporterKycApplication(
            UUID profileId
    ) {

        TransporterProfileEntity profile =
                transporterProfileRepository
                        .findById(profileId)
                        .orElseThrow(() ->
                                new ResourceNotFoundException(
                                        "Transporter profile not found: "
                                                + profileId
                                )
                        );

        return mapTransporterToResponse(
                profile
        );
    }

    @Transactional
    @AuditLog(
            action = "KYC_TRANSPORTER_APPROVED",
            entityType = "TRANSPORTER_PROFILE"
    )
    public TransporterProfileResponseDto
    approveTransporterKyc(
            UUID profileId
    ) {

        TransporterProfileEntity profile =
                transporterProfileRepository
                        .findById(profileId)
                        .orElseThrow(() ->
                                new ResourceNotFoundException(
                                        "Transporter profile not found: "
                                                + profileId
                                )
                        );

        validateSubmittedStatus(
                profile.getVerificationStatus()
        );

        profile.setVerificationStatus(
                KycStatus.VERIFIED
        );

        profile.setVerifiedAt(
                Instant.now()
        );

        profile.setRejectionReason(
                null
        );

        TransporterProfileEntity saved =
                transporterProfileRepository.save(
                        profile
                );

        return mapTransporterToResponse(
                saved
        );
    }

    @Transactional
    @AuditLog(
            action = "KYC_TRANSPORTER_REJECTED",
            entityType = "TRANSPORTER_PROFILE"
    )
    public TransporterProfileResponseDto
    rejectTransporterKyc(
            UUID profileId,
            KycRejectionRequestDto request
    ) {

        TransporterProfileEntity profile =
                transporterProfileRepository
                        .findById(profileId)
                        .orElseThrow(() ->
                                new ResourceNotFoundException(
                                        "Transporter profile not found: "
                                                + profileId
                                )
                        );

        validateSubmittedStatus(
                profile.getVerificationStatus()
        );

        String reason =
                request.getRejectionReason()
                        .trim();

        if (reason.isBlank()) {

            throw new IllegalArgumentException(
                    "Rejection reason is required"
            );
        }

        profile.setVerificationStatus(
                KycStatus.REJECTED
        );

        profile.setRejectionReason(
                reason
        );

        profile.setVerifiedAt(
                null
        );

        TransporterProfileEntity saved =
                transporterProfileRepository.save(
                        profile
                );

        return mapTransporterToResponse(
                saved
        );
    }

    private void validateSubmittedStatus(
            KycStatus status
    ) {

        if (status != KycStatus.SUBMITTED) {

            throw new IllegalArgumentException(
                    "Only SUBMITTED KYC applications can be reviewed. Current status: "
                            + status
            );
        }
    }

    private CompanyProfileResponseDto
    mapCompanyToResponse(
            CompanyProfileEntity profile
    ) {

        UserEntity user =
                profile.getUser();

        return CompanyProfileResponseDto.builder()
                .id(profile.getId())
                .userId(user.getId())
                .companyName(profile.getCompanyName())
                .ownerName(user.getFullName())
                .email(user.getEmail())
                .phone(user.getPhone())
                .address(profile.getAddress())
                .gstNumber(profile.getGstNumber())
                .licenseNumber(profile.getLicenseNumber())
                .verificationStatus(
                        profile.getVerificationStatus()
                )
                .rejectionReason(
                        profile.getRejectionReason()
                )
                .submittedAt(
                        profile.getSubmittedAt()
                )
                .verifiedAt(
                        profile.getVerifiedAt()
                )
                .createdAt(
                        profile.getCreatedAt()
                )
                .build();
    }

    private TransporterProfileResponseDto
    mapTransporterToResponse(
            TransporterProfileEntity profile
    ) {

        UserEntity user =
                profile.getUser();

        return TransporterProfileResponseDto.builder()
                .id(profile.getId())
                .userId(user.getId())
                .companyName(profile.getCompanyName())
                .ownerName(user.getFullName())
                .email(user.getEmail())
                .phone(user.getPhone())
                .vehicleType(profile.getVehicleType())
                .fleetSize(profile.getFleetSize())
                .licenseNumber(profile.getLicenseNumber())
                .completedDeliveries(
                        profile.getCompletedDeliveries()
                )
                .rating(
                        profile.getRating()
                )
                .verificationStatus(
                        profile.getVerificationStatus()
                )
                .rejectionReason(
                        profile.getRejectionReason()
                )
                .submittedAt(
                        profile.getSubmittedAt()
                )
                .verifiedAt(
                        profile.getVerifiedAt()
                )
                .createdAt(
                        profile.getCreatedAt()
                )
                .build();
    }
}