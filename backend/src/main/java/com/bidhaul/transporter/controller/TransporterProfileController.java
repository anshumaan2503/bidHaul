package com.bidhaul.transporter.controller;

import com.bidhaul.security.util.SecurityUtils;
import com.bidhaul.transporter.dto.request.CreateTransporterProfileRequestDto;
import com.bidhaul.transporter.dto.request.UpdateTransporterProfileRequestDto;
import com.bidhaul.transporter.dto.response.TransporterProfileResponseDto;
import com.bidhaul.transporter.service.TransporterProfileService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@RestController
@RequestMapping("/api/v1/transporter")
@RequiredArgsConstructor
public class TransporterProfileController {

    private final TransporterProfileService transporterProfileService;

    @GetMapping("/profile")
    @PreAuthorize("hasRole('TRANSPORTER')")
    public ResponseEntity<TransporterProfileResponseDto> getProfile() {
        UUID userId = getAuthenticatedUserId();
        return ResponseEntity.ok(transporterProfileService.getProfile(userId));
    }

    @PostMapping("/profile")
    @PreAuthorize("hasRole('TRANSPORTER')")
    public ResponseEntity<TransporterProfileResponseDto> createProfile(@Valid @RequestBody CreateTransporterProfileRequestDto request) {
        UUID userId = getAuthenticatedUserId();
        TransporterProfileResponseDto response = transporterProfileService.createProfile(userId, request);
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    @PutMapping("/profile")
    @PreAuthorize("hasRole('TRANSPORTER')")
    public ResponseEntity<TransporterProfileResponseDto> updateProfile(@Valid @RequestBody UpdateTransporterProfileRequestDto request) {
        UUID userId = getAuthenticatedUserId();
        return ResponseEntity.ok(transporterProfileService.updateProfile(userId, request));
    }

    @PostMapping("/kyc/submit")
    @PreAuthorize("hasRole('TRANSPORTER')")
    public ResponseEntity<TransporterProfileResponseDto> submitKyc() {
        UUID userId = getAuthenticatedUserId();
        return ResponseEntity.ok(transporterProfileService.submitKyc(userId));
    }

    private UUID getAuthenticatedUserId() {
        return SecurityUtils.getCurrentUserId()
                .orElseThrow(() -> new AccessDeniedException("User is not authenticated"));
    }
}
