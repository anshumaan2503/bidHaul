package com.bidhaul.subscription.controller;

import com.bidhaul.subscription.dto.request.CreateSubscriptionPlanRequestDto;
import com.bidhaul.subscription.dto.request.SubscribeRequestDto;
import com.bidhaul.subscription.dto.response.SubscriptionPlanResponseDto;
import com.bidhaul.subscription.dto.response.UserSubscriptionResponseDto;
import com.bidhaul.subscription.service.SubscriptionService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/subscriptions")
@RequiredArgsConstructor
public class SubscriptionController {

    private final SubscriptionService subscriptionService;

    /**
     * Returns all currently active platform subscription plans.
     */
    @GetMapping("/plans")
    @PreAuthorize("hasAnyRole('COMPANY', 'TRANSPORTER')")
    public ResponseEntity<List<SubscriptionPlanResponseDto>>
    getActivePlans() {

        return ResponseEntity.ok(
                subscriptionService.getActivePlans()
        );
    }

    /**
     * Super Admin creates a platform subscription plan.
     */
    @PostMapping("/plans")
    @PreAuthorize("hasRole('SUPER_ADMIN')")
    public ResponseEntity<SubscriptionPlanResponseDto>
    createPlan(
            @Valid @RequestBody CreateSubscriptionPlanRequestDto request
    ) {

        return ResponseEntity
                .status(HttpStatus.CREATED)
                .body(
                        subscriptionService.createPlan(
                                request
                        )
                );
    }

    /**
     * Creates a subscription awaiting payment.
     *
     * Razorpay integration is intentionally handled
     * by the separate payment module.
     */
    @PostMapping("/subscribe")
    @PreAuthorize("hasAnyRole('COMPANY', 'TRANSPORTER')")
    public ResponseEntity<UserSubscriptionResponseDto>
    subscribe(
            @Valid @RequestBody SubscribeRequestDto request
    ) {

        return ResponseEntity
                .status(HttpStatus.CREATED)
                .body(
                        subscriptionService.subscribe(
                                request
                        )
                );
    }

    /**
     * Returns only the currently active subscription.
     */
    @GetMapping("/me")
    @PreAuthorize("hasAnyRole('COMPANY', 'TRANSPORTER')")
    public ResponseEntity<UserSubscriptionResponseDto>
    getMySubscription() {

        return ResponseEntity.ok(
                subscriptionService.getMySubscription()
        );
    }

    /**
     * Returns the latest subscription state, including
     * PENDING_PAYMENT and EXPIRED states.
     */
    @GetMapping("/me/status")
    @PreAuthorize("hasAnyRole('COMPANY', 'TRANSPORTER')")
    public ResponseEntity<UserSubscriptionResponseDto>
    getMySubscriptionStatus() {

        return ResponseEntity.ok(
                subscriptionService.getMySubscriptionStatus()
        );
    }

    /**
     * Returns the complete subscription history for
     * the authenticated user.
     */
    @GetMapping("/me/history")
    @PreAuthorize("hasAnyRole('COMPANY', 'TRANSPORTER')")
    public ResponseEntity<List<UserSubscriptionResponseDto>>
    getMySubscriptionHistory() {

        return ResponseEntity.ok(
                subscriptionService.getMySubscriptionHistory()
        );
    }
}