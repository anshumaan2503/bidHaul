package com.bidhaul.transporter.service;

import com.bidhaul.common.enums.KycStatus;
import com.bidhaul.common.enums.UserType;
import com.bidhaul.common.exception.DuplicateResourceException;
import com.bidhaul.common.exception.ResourceNotFoundException;
import com.bidhaul.transporter.dto.request.CreateTransporterProfileRequestDto;
import com.bidhaul.transporter.dto.request.UpdateTransporterProfileRequestDto;
import com.bidhaul.transporter.dto.response.TransporterProfileResponseDto;
import com.bidhaul.transporter.entity.TransporterProfileEntity;
import com.bidhaul.transporter.repository.TransporterProfileRepository;
import com.bidhaul.user.entity.UserEntity;
import com.bidhaul.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class TransporterProfileService {

    private final TransporterProfileRepository transporterProfileRepository;
    private final UserRepository userRepository;

    @Transactional(readOnly = true)
    public TransporterProfileResponseDto getProfile(UUID userId) {
        TransporterProfileEntity profile =
                transporterProfileRepository.findByUserId(userId)
                        .orElseThrow(() ->
                                new ResourceNotFoundException(
                                        "Transporter profile not found for user: "
                                                + userId
                                )
                        );

        return mapToResponseDto(profile);
    }

    @Transactional
    public TransporterProfileResponseDto createProfile(
            UUID userId,
            CreateTransporterProfileRequestDto request
    ) {
        UserEntity user = userRepository.findById(userId)
                .orElseThrow(() ->
                        new ResourceNotFoundException(
                                "User not found: " + userId
                        )
                );

        if (user.getUserType() != UserType.TRANSPORTER) {
            throw new IllegalArgumentException(
                    "Only users with TRANSPORTER role can create a transporter profile"
            );
        }

        if (transporterProfileRepository.existsByUserId(userId)) {
            throw new DuplicateResourceException(
                    "Transporter profile already exists for user: " + userId
            );
        }

        String normalizedLicense =
                normalizeString(request.getLicenseNumber());

        if (normalizedLicense != null &&
                transporterProfileRepository.existsByLicenseNumber(
                        normalizedLicense
                )) {

            throw new DuplicateResourceException(
                    "Transporter license number already registered: "
                            + normalizedLicense
            );
        }

        TransporterProfileEntity profile =
                TransporterProfileEntity.builder()
                        .user(user)
                        .companyName(request.getCompanyName().trim())
                        .vehicleType(request.getVehicleType().trim())
                        .fleetSize(request.getFleetSize())
                        .licenseNumber(normalizedLicense)
                        .completedDeliveries(0)
                        .rating(null)
                        .verificationStatus(KycStatus.PENDING)
                        .build();

        TransporterProfileEntity saved =
                transporterProfileRepository.save(profile);

        return mapToResponseDto(saved);
    }

    @Transactional
    public TransporterProfileResponseDto updateProfile(
            UUID userId,
            UpdateTransporterProfileRequestDto request
    ) {
        TransporterProfileEntity profile =
                transporterProfileRepository.findByUserId(userId)
                        .orElseThrow(() ->
                                new ResourceNotFoundException(
                                        "Transporter profile not found for user: "
                                                + userId
                                )
                        );

        String normalizedLicense =
                normalizeString(request.getLicenseNumber());

        if (normalizedLicense != null &&
                !normalizedLicense.equalsIgnoreCase(
                        profile.getLicenseNumber()
                )) {

            if (transporterProfileRepository.existsByLicenseNumber(
                    normalizedLicense
            )) {

                throw new DuplicateResourceException(
                        "Transporter license number already registered: "
                                + normalizedLicense
                );
            }
        }

        profile.setCompanyName(request.getCompanyName().trim());
        profile.setVehicleType(request.getVehicleType().trim());
        profile.setFleetSize(request.getFleetSize());
        profile.setLicenseNumber(normalizedLicense);

        /*
         * Any profile modification after verification invalidates
         * the previous KYC verification.
         */
        if (profile.getVerificationStatus() == KycStatus.VERIFIED) {
            profile.setVerificationStatus(KycStatus.PENDING);
            profile.setVerifiedAt(null);
            profile.setSubmittedAt(null);
            profile.setRejectionReason(null);
        }

        TransporterProfileEntity updated =
                transporterProfileRepository.save(profile);

        return mapToResponseDto(updated);
    }

    @Transactional
    public TransporterProfileResponseDto submitKyc(UUID userId) {
        TransporterProfileEntity profile =
                transporterProfileRepository.findByUserId(userId)
                        .orElseThrow(() ->
                                new ResourceNotFoundException(
                                        "Transporter profile not found for user: "
                                                + userId
                                )
                        );

        KycStatus currentStatus = profile.getVerificationStatus();

        if (currentStatus != KycStatus.PENDING &&
                currentStatus != KycStatus.REJECTED) {

            throw new IllegalArgumentException(
                    "KYC submission is not allowed from status: "
                            + currentStatus
            );
        }

        if (profile.getCompanyName() == null ||
                profile.getCompanyName().isBlank()) {

            throw new IllegalArgumentException(
                    "Company name is required for KYC submission"
            );
        }

        if (profile.getVehicleType() == null ||
                profile.getVehicleType().isBlank()) {

            throw new IllegalArgumentException(
                    "Vehicle type is required for KYC submission"
            );
        }

        if (profile.getFleetSize() == null ||
                profile.getFleetSize() < 0) {

            throw new IllegalArgumentException(
                    "Valid fleet size is required for KYC submission"
            );
        }

        if (profile.getLicenseNumber() == null ||
                profile.getLicenseNumber().isBlank()) {

            throw new IllegalArgumentException(
                    "License number is required for KYC submission"
            );
        }

        profile.setVerificationStatus(KycStatus.SUBMITTED);
        profile.setSubmittedAt(Instant.now());
        profile.setVerifiedAt(null);
        profile.setRejectionReason(null);

        TransporterProfileEntity updated =
                transporterProfileRepository.save(profile);

        return mapToResponseDto(updated);
    }

    private String normalizeString(String input) {
        if (input == null || input.isBlank()) {
            return null;
        }

        return input.trim().toUpperCase();
    }

    private TransporterProfileResponseDto mapToResponseDto(
            TransporterProfileEntity profile
    ) {
        UserEntity user = profile.getUser();

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
                .completedDeliveries(profile.getCompletedDeliveries())
                .rating(profile.getRating())
                .verificationStatus(profile.getVerificationStatus())
                .rejectionReason(profile.getRejectionReason())
                .submittedAt(profile.getSubmittedAt())
                .verifiedAt(profile.getVerifiedAt())
                .createdAt(profile.getCreatedAt())
                .build();
    }
}