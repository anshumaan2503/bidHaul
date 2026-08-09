package com.bidhaul.company.service;

import com.bidhaul.common.enums.KycStatus;
import com.bidhaul.common.enums.UserType;
import com.bidhaul.common.exception.DuplicateResourceException;
import com.bidhaul.common.exception.ResourceNotFoundException;
import com.bidhaul.company.dto.request.CreateCompanyProfileRequestDto;
import com.bidhaul.company.dto.request.UpdateCompanyProfileRequestDto;
import com.bidhaul.company.dto.response.CompanyProfileResponseDto;
import com.bidhaul.company.entity.CompanyProfileEntity;
import com.bidhaul.company.repository.CompanyProfileRepository;
import com.bidhaul.user.entity.UserEntity;
import com.bidhaul.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;
import java.util.UUID;
import java.util.regex.Pattern;

@Service
@RequiredArgsConstructor
public class CompanyProfileService {

    private static final Pattern GST_PATTERN = Pattern.compile(
            "^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$"
    );

    private final CompanyProfileRepository companyProfileRepository;
    private final UserRepository userRepository;

    @Transactional(readOnly = true)
    public CompanyProfileResponseDto getProfile(UUID userId) {
        CompanyProfileEntity profile = companyProfileRepository.findByUserId(userId)
                .orElseThrow(() ->
                        new ResourceNotFoundException(
                                "Company profile not found for user: " + userId
                        )
                );

        return mapToResponseDto(profile);
    }

    @Transactional
    public CompanyProfileResponseDto createProfile(
            UUID userId,
            CreateCompanyProfileRequestDto request
    ) {
        UserEntity user = userRepository.findById(userId)
                .orElseThrow(() ->
                        new ResourceNotFoundException("User not found: " + userId)
                );

        if (user.getUserType() != UserType.COMPANY) {
            throw new IllegalArgumentException(
                    "Only users with COMPANY role can create a company profile"
            );
        }

        if (companyProfileRepository.existsByUserId(userId)) {
            throw new DuplicateResourceException(
                    "Company profile already exists for user: " + userId
            );
        }

        String normalizedGst = normalizeString(request.getGstNumber());
        String normalizedLicense = normalizeString(request.getLicenseNumber());

        if (normalizedGst != null &&
                companyProfileRepository.existsByGstNumber(normalizedGst)) {

            throw new DuplicateResourceException(
                    "Company GST number already registered: " + normalizedGst
            );
        }

        if (normalizedLicense != null &&
                companyProfileRepository.existsByLicenseNumber(normalizedLicense)) {

            throw new DuplicateResourceException(
                    "Company license number already registered: " + normalizedLicense
            );
        }

        CompanyProfileEntity profile = CompanyProfileEntity.builder()
                .user(user)
                .companyName(request.getCompanyName().trim())
                .address(request.getAddress() != null
                        ? request.getAddress().trim()
                        : null)
                .gstNumber(normalizedGst)
                .licenseNumber(normalizedLicense)
                .verificationStatus(KycStatus.PENDING)
                .build();

        CompanyProfileEntity saved = companyProfileRepository.save(profile);

        return mapToResponseDto(saved);
    }

    @Transactional
    public CompanyProfileResponseDto updateProfile(
            UUID userId,
            UpdateCompanyProfileRequestDto request
    ) {
        CompanyProfileEntity profile = companyProfileRepository.findByUserId(userId)
                .orElseThrow(() ->
                        new ResourceNotFoundException(
                                "Company profile not found for user: " + userId
                        )
                );

        String normalizedGst = normalizeString(request.getGstNumber());
        String normalizedLicense = normalizeString(request.getLicenseNumber());

        if (normalizedGst != null &&
                !normalizedGst.equalsIgnoreCase(profile.getGstNumber())) {

            if (companyProfileRepository.existsByGstNumber(normalizedGst)) {
                throw new DuplicateResourceException(
                        "Company GST number already registered: " + normalizedGst
                );
            }
        }

        if (normalizedLicense != null &&
                !normalizedLicense.equalsIgnoreCase(profile.getLicenseNumber())) {

            if (companyProfileRepository.existsByLicenseNumber(normalizedLicense)) {
                throw new DuplicateResourceException(
                        "Company license number already registered: " + normalizedLicense
                );
            }
        }

        profile.setCompanyName(request.getCompanyName().trim());
        profile.setAddress(
                request.getAddress() != null
                        ? request.getAddress().trim()
                        : null
        );
        profile.setGstNumber(normalizedGst);
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

        CompanyProfileEntity updated = companyProfileRepository.save(profile);

        return mapToResponseDto(updated);
    }

    @Transactional
    public CompanyProfileResponseDto submitKyc(UUID userId) {
        CompanyProfileEntity profile = companyProfileRepository.findByUserId(userId)
                .orElseThrow(() ->
                        new ResourceNotFoundException(
                                "Company profile not found for user: " + userId
                        )
                );

        KycStatus currentStatus = profile.getVerificationStatus();

        if (currentStatus != KycStatus.PENDING &&
                currentStatus != KycStatus.REJECTED) {

            throw new IllegalArgumentException(
                    "KYC submission is not allowed from status: " + currentStatus
            );
        }

        if (profile.getCompanyName() == null ||
                profile.getCompanyName().isBlank()) {

            throw new IllegalArgumentException(
                    "Company name is required for KYC submission"
            );
        }

        if (profile.getAddress() == null ||
                profile.getAddress().isBlank()) {

            throw new IllegalArgumentException(
                    "Company address is required for KYC submission"
            );
        }

        if (profile.getGstNumber() == null ||
                profile.getGstNumber().isBlank()) {

            throw new IllegalArgumentException(
                    "GST number is required for KYC submission"
            );
        }

        if (!GST_PATTERN.matcher(profile.getGstNumber()).matches()) {
            throw new IllegalArgumentException(
                    "Invalid GST number format for KYC submission: "
                            + profile.getGstNumber()
            );
        }

        profile.setVerificationStatus(KycStatus.SUBMITTED);
        profile.setSubmittedAt(Instant.now());
        profile.setVerifiedAt(null);
        profile.setRejectionReason(null);

        CompanyProfileEntity updated =
                companyProfileRepository.save(profile);

        return mapToResponseDto(updated);
    }

    private String normalizeString(String input) {
        if (input == null || input.isBlank()) {
            return null;
        }

        return input.trim().toUpperCase();
    }

    private CompanyProfileResponseDto mapToResponseDto(
            CompanyProfileEntity profile
    ) {
        UserEntity user = profile.getUser();

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
                .verificationStatus(profile.getVerificationStatus())
                .rejectionReason(profile.getRejectionReason())
                .submittedAt(profile.getSubmittedAt())
                .verifiedAt(profile.getVerifiedAt())
                .createdAt(profile.getCreatedAt())
                .build();
    }
}