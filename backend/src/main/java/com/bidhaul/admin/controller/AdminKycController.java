package com.bidhaul.admin.controller;

import com.bidhaul.admin.dto.request.KycRejectionRequestDto;
import com.bidhaul.admin.service.AdminKycService;
import com.bidhaul.common.enums.KycStatus;
import com.bidhaul.company.dto.response.CompanyProfileResponseDto;
import com.bidhaul.transporter.dto.response.TransporterProfileResponseDto;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1/admin/kyc")
@RequiredArgsConstructor
@PreAuthorize("hasAnyRole('ADMIN', 'SUPER_ADMIN')")
public class AdminKycController {

    private final AdminKycService adminKycService;

    @GetMapping("/companies")
    public ResponseEntity<List<CompanyProfileResponseDto>> getCompanyKycApplications(
            @RequestParam(required = false) KycStatus status
    ) {
        return ResponseEntity.ok(
                adminKycService.getCompanyKycApplications(status)
        );
    }

    @GetMapping("/companies/{profileId}")
    public ResponseEntity<CompanyProfileResponseDto> getCompanyKycApplication(
            @PathVariable UUID profileId
    ) {
        return ResponseEntity.ok(
                adminKycService.getCompanyKycApplication(profileId)
        );
    }

    @PostMapping("/companies/{profileId}/approve")
    public ResponseEntity<CompanyProfileResponseDto> approveCompanyKyc(
            @PathVariable UUID profileId
    ) {
        return ResponseEntity.ok(
                adminKycService.approveCompanyKyc(profileId)
        );
    }

    @PostMapping("/companies/{profileId}/reject")
    public ResponseEntity<CompanyProfileResponseDto> rejectCompanyKyc(
            @PathVariable UUID profileId,
            @Valid @RequestBody KycRejectionRequestDto request
    ) {
        return ResponseEntity.ok(
                adminKycService.rejectCompanyKyc(
                        profileId,
                        request
                )
        );
    }

    @GetMapping("/transporters")
    public ResponseEntity<List<TransporterProfileResponseDto>> getTransporterKycApplications(
            @RequestParam(required = false) KycStatus status
    ) {
        return ResponseEntity.ok(
                adminKycService.getTransporterKycApplications(status)
        );
    }

    @GetMapping("/transporters/{profileId}")
    public ResponseEntity<TransporterProfileResponseDto> getTransporterKycApplication(
            @PathVariable UUID profileId
    ) {
        return ResponseEntity.ok(
                adminKycService.getTransporterKycApplication(profileId)
        );
    }

    @PostMapping("/transporters/{profileId}/approve")
    public ResponseEntity<TransporterProfileResponseDto> approveTransporterKyc(
            @PathVariable UUID profileId
    ) {
        return ResponseEntity.ok(
                adminKycService.approveTransporterKyc(profileId)
        );
    }

    @PostMapping("/transporters/{profileId}/reject")
    public ResponseEntity<TransporterProfileResponseDto> rejectTransporterKyc(
            @PathVariable UUID profileId,
            @Valid @RequestBody KycRejectionRequestDto request
    ) {
        return ResponseEntity.ok(
                adminKycService.rejectTransporterKyc(
                        profileId,
                        request
                )
        );
    }
}