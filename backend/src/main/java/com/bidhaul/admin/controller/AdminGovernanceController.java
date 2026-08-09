package com.bidhaul.admin.controller;

import com.bidhaul.admin.dto.response.AdminDashboardResponseDto;
import com.bidhaul.admin.service.AdminGovernanceService;
import com.bidhaul.security.util.SecurityUtils;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@RestController
@RequestMapping("/api/v1/admin")
@RequiredArgsConstructor
@PreAuthorize(
        "hasAnyRole('ADMIN', 'SUPER_ADMIN')"
)
public class AdminGovernanceController {

    private final AdminGovernanceService adminGovernanceService;

    @GetMapping("/dashboard")
    public ResponseEntity<AdminDashboardResponseDto>
    getDashboard() {

        return ResponseEntity.ok(
                adminGovernanceService.getDashboard()
        );
    }

    @PatchMapping("/users/{userId}/suspend")
    public ResponseEntity<Void> suspendUser(
            @PathVariable UUID userId
    ) {

        adminGovernanceService.suspendUser(
                userId,
                getAuthenticatedUserId()
        );

        return ResponseEntity
                .noContent()
                .build();
    }

    @PatchMapping("/users/{userId}/activate")
    public ResponseEntity<Void> activateUser(
            @PathVariable UUID userId
    ) {

        adminGovernanceService.activateUser(
                userId,
                getAuthenticatedUserId()
        );

        return ResponseEntity
                .noContent()
                .build();
    }

    @GetMapping("/payment-gateway/status")
    public ResponseEntity<java.util.Map<String, Boolean>> getPaymentGatewayStatus() {
        return ResponseEntity.ok(
                java.util.Map.of("enabled", com.bidhaul.payment.service.PaymentService.isPaymentGatewayEnabled())
        );
    }

    @PostMapping("/payment-gateway/toggle")
    @PreAuthorize("hasRole('SUPER_ADMIN')")
    public ResponseEntity<java.util.Map<String, Boolean>> togglePaymentGateway() {
        boolean current = com.bidhaul.payment.service.PaymentService.isPaymentGatewayEnabled();
        boolean nextState = !current;
        com.bidhaul.payment.service.PaymentService.setPaymentGatewayEnabled(nextState);
        return ResponseEntity.ok(
                java.util.Map.of("enabled", nextState)
        );
    }

    private UUID getAuthenticatedUserId() {

        return SecurityUtils
                .getCurrentUserId()
                .orElseThrow(() ->
                        new AccessDeniedException(
                                "User is not authenticated"
                        )
                );
    }
}