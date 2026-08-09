package com.bidhaul.company.controller;

import com.bidhaul.company.dto.request.CreateCompanyProfileRequestDto;
import com.bidhaul.company.dto.request.UpdateCompanyProfileRequestDto;
import com.bidhaul.company.dto.response.CompanyProfileResponseDto;
import com.bidhaul.company.service.CompanyProfileService;
import com.bidhaul.security.util.SecurityUtils;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@RestController
@RequestMapping("/api/v1/company")
@RequiredArgsConstructor
public class CompanyProfileController {

    private final CompanyProfileService companyProfileService;

    @GetMapping("/profile")
    @PreAuthorize("hasRole('COMPANY')")
    public ResponseEntity<CompanyProfileResponseDto> getProfile() {
        UUID userId = getAuthenticatedUserId();
        return ResponseEntity.ok(companyProfileService.getProfile(userId));
    }

    @PostMapping("/profile")
    @PreAuthorize("hasRole('COMPANY')")
    public ResponseEntity<CompanyProfileResponseDto> createProfile(@Valid @RequestBody CreateCompanyProfileRequestDto request) {
        UUID userId = getAuthenticatedUserId();
        CompanyProfileResponseDto response = companyProfileService.createProfile(userId, request);
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    @PutMapping("/profile")
    @PreAuthorize("hasRole('COMPANY')")
    public ResponseEntity<CompanyProfileResponseDto> updateProfile(@Valid @RequestBody UpdateCompanyProfileRequestDto request) {
        UUID userId = getAuthenticatedUserId();
        return ResponseEntity.ok(companyProfileService.updateProfile(userId, request));
    }

    @PostMapping("/kyc/submit")
    @PreAuthorize("hasRole('COMPANY')")
    public ResponseEntity<CompanyProfileResponseDto> submitKyc() {
        UUID userId = getAuthenticatedUserId();
        return ResponseEntity.ok(companyProfileService.submitKyc(userId));
    }

    private UUID getAuthenticatedUserId() {
        return SecurityUtils.getCurrentUserId()
                .orElseThrow(() -> new AccessDeniedException("User is not authenticated"));
    }
}
