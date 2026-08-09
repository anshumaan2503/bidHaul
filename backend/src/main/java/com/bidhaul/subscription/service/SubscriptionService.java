package com.bidhaul.subscription.service;

import com.bidhaul.common.enums.UserType;
import com.bidhaul.invoice.entity.InvoiceEntity;
import com.bidhaul.invoice.service.InvoiceService;
import com.bidhaul.notification.enums.NotificationType;
import com.bidhaul.notification.service.NotificationService;
import com.bidhaul.security.util.SecurityUtils;
import com.bidhaul.subscription.dto.request.CreateSubscriptionPlanRequestDto;
import com.bidhaul.subscription.dto.request.SubscribeRequestDto;
import com.bidhaul.subscription.dto.response.SubscriptionPlanResponseDto;
import com.bidhaul.subscription.dto.response.UserSubscriptionResponseDto;
import com.bidhaul.subscription.entity.SubscriptionPlanEntity;
import com.bidhaul.subscription.entity.UserSubscriptionEntity;
import com.bidhaul.subscription.enums.BillingCycle;
import com.bidhaul.subscription.enums.SubscriptionStatus;
import com.bidhaul.subscription.repository.SubscriptionPlanRepository;
import com.bidhaul.subscription.repository.UserSubscriptionRepository;
import com.bidhaul.user.entity.UserEntity;
import com.bidhaul.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class SubscriptionService {

    private final SubscriptionPlanRepository planRepository;

    private final UserSubscriptionRepository subscriptionRepository;

    private final UserRepository userRepository;

    private final InvoiceService invoiceService;

    private final NotificationService notificationService;

    @Transactional(readOnly = true)
    public List<SubscriptionPlanResponseDto> getActivePlans() {

        return planRepository
                .findByActiveTrueOrderByMonthlyPriceAsc()
                .stream()
                .map(
                        SubscriptionPlanResponseDto::from
                )
                .toList();
    }

    @Transactional
    public SubscriptionPlanResponseDto createPlan(
            CreateSubscriptionPlanRequestDto request
    ) {

        if (planRepository.existsByNameIgnoreCase(
                request.getName().trim()
        )) {

            throw new ResponseStatusException(
                    HttpStatus.CONFLICT,
                    "A subscription plan with this name already exists"
            );
        }

        SubscriptionPlanEntity plan =
                SubscriptionPlanEntity.builder()
                        .name(
                                request.getName().trim()
                        )
                        .monthlyPrice(
                                request.getMonthlyPrice()
                        )
                        .description(
                                request.getDescription().trim()
                        )
                        .features(
                                request.getFeatures().trim()
                        )
                        .recommended(
                                request.isRecommended()
                        )
                        .active(true)
                        .build();

        return SubscriptionPlanResponseDto.from(
                planRepository.save(plan)
        );
    }

    @Transactional
    public UserSubscriptionResponseDto subscribe(
            SubscribeRequestDto request
    ) {

        UUID userId =
                getCurrentUserId();

        UserEntity user =
                userRepository.findById(
                                userId
                        )
                        .orElseThrow(() ->
                                new ResponseStatusException(
                                        HttpStatus.NOT_FOUND,
                                        "Authenticated user not found"
                                )
                        );

        ensureSubscriptionEligibleUser(
                user
        );

        SubscriptionPlanEntity plan =
                planRepository.findById(
                                request.getPlanId()
                        )
                        .orElseThrow(() ->
                                new ResponseStatusException(
                                        HttpStatus.NOT_FOUND,
                                        "Subscription plan not found"
                                )
                        );

        if (!plan.isActive()) {

            throw new ResponseStatusException(
                    HttpStatus.CONFLICT,
                    "The selected subscription plan is inactive"
            );
        }

        expireExistingSubscriptionIfNecessary(
                userId
        );

        boolean hasPendingPayment =
                subscriptionRepository
                        .existsByUserIdAndStatus(
                                userId,
                                SubscriptionStatus.PENDING_PAYMENT
                        );

        if (hasPendingPayment) {

            throw new ResponseStatusException(
                    HttpStatus.CONFLICT,
                    "You already have a subscription awaiting payment"
            );
        }

        boolean hasActiveSubscription =
                subscriptionRepository
                        .existsByUserIdAndStatus(
                                userId,
                                SubscriptionStatus.ACTIVE
                        );

        if (hasActiveSubscription) {

            throw new ResponseStatusException(
                    HttpStatus.CONFLICT,
                    "You already have an active subscription"
            );
        }

        UserSubscriptionEntity subscription =
                UserSubscriptionEntity.builder()
                        .user(user)
                        .plan(plan)
                        .billingCycle(
                                request.getBillingCycle()
                        )
                        .status(
                                SubscriptionStatus.PENDING_PAYMENT
                        )
                        .priceAtSubscription(
                                plan.getMonthlyPrice()
                        )
                        .build();

        UserSubscriptionEntity savedSubscription =
                subscriptionRepository.save(
                        subscription
                );

        InvoiceEntity invoice =
                invoiceService.createPendingInvoice(
                        savedSubscription
                );

        if (invoice == null ||
                invoice.getId() == null) {

            throw new ResponseStatusException(
                    HttpStatus.INTERNAL_SERVER_ERROR,
                    "Failed to provision subscription invoice"
            );
        }

        /*
         * Publish notification only after the subscription
         * and invoice have successfully been created.
         *
         * Notification processing itself is asynchronous.
         */
        notificationService.publishNotification(
                userId,
                NotificationType.SUBSCRIPTION,
                "Subscription created",
                "Your "
                        + plan.getName()
                        + " subscription is awaiting payment.",
                "SUBSCRIPTION",
                savedSubscription.getId()
        );

        notificationService.publishNotification(
                userId,
                NotificationType.INVOICE,
                "Invoice generated",
                "Invoice "
                        + invoice.getInvoiceNumber()
                        + " has been generated for your subscription.",
                "INVOICE",
                invoice.getId()
        );

        return UserSubscriptionResponseDto.from(
                savedSubscription
        );
    }

    @Transactional(readOnly = true)
    public UserSubscriptionResponseDto getMySubscription() {

        UUID userId =
                getCurrentUserId();

        UserSubscriptionEntity subscription =
                subscriptionRepository
                        .findFirstByUserIdAndStatusOrderByCreatedAtDesc(
                                userId,
                                SubscriptionStatus.ACTIVE
                        )
                        .orElseThrow(() ->
                                new ResponseStatusException(
                                        HttpStatus.NOT_FOUND,
                                        "No active subscription found"
                                )
                        );

        return UserSubscriptionResponseDto.from(
                subscription
        );
    }

    @Transactional
    public UserSubscriptionResponseDto getMySubscriptionStatus() {

        UUID userId =
                getCurrentUserId();

        expireExistingSubscriptionIfNecessary(
                userId
        );

        UserSubscriptionEntity subscription =
                subscriptionRepository
                        .findTopByUserIdOrderByCreatedAtDesc(
                                userId
                        )
                        .orElseThrow(() ->
                                new ResponseStatusException(
                                        HttpStatus.NOT_FOUND,
                                        "No subscription found"
                                )
                        );

        return UserSubscriptionResponseDto.from(
                subscription
        );
    }

    @Transactional(readOnly = true)
    public List<UserSubscriptionResponseDto>
    getMySubscriptionHistory() {

        UUID userId =
                getCurrentUserId();

        return subscriptionRepository
                .findByUserIdOrderByCreatedAtDesc(
                        userId
                )
                .stream()
                .map(
                        UserSubscriptionResponseDto::from
                )
                .toList();
    }

    @Transactional
    public UserSubscriptionResponseDto activateSubscription(
            UUID subscriptionId
    ) {

        UserSubscriptionEntity subscription =
                subscriptionRepository.findById(
                                subscriptionId
                        )
                        .orElseThrow(() ->
                                new ResponseStatusException(
                                        HttpStatus.NOT_FOUND,
                                        "Subscription not found"
                                )
                        );

        if (subscription.getStatus() !=
                SubscriptionStatus.PENDING_PAYMENT) {

            throw new ResponseStatusException(
                    HttpStatus.CONFLICT,
                    "Only subscriptions awaiting payment can be activated"
            );
        }

        UUID userId =
                subscription.getUser().getId();

        expireExistingSubscriptionIfNecessary(
                userId
        );

        boolean anotherActiveSubscription =
                subscriptionRepository
                        .existsByUserIdAndStatus(
                                userId,
                                SubscriptionStatus.ACTIVE
                        );

        if (anotherActiveSubscription) {

            throw new ResponseStatusException(
                    HttpStatus.CONFLICT,
                    "User already has an active subscription"
            );
        }

        Instant start =
                Instant.now();

        Instant expiry;

        if (subscription.getBillingCycle() ==
                BillingCycle.ANNUAL) {

            expiry =
                    start.plus(
                            365,
                            ChronoUnit.DAYS
                    );

        } else {

            expiry =
                    start.plus(
                            30,
                            ChronoUnit.DAYS
                    );
        }

        subscription.setStartsAt(
                start
        );

        subscription.setExpiresAt(
                expiry
        );

        subscription.setStatus(
                SubscriptionStatus.ACTIVE
        );

        UserSubscriptionEntity saved =
                subscriptionRepository.save(
                        subscription
                );

        notificationService.publishNotification(
                userId,
                NotificationType.SUBSCRIPTION,
                "Subscription activated",
                "Your "
                        + subscription.getPlan().getName()
                        + " subscription is now active.",
                "SUBSCRIPTION",
                subscription.getId()
        );

        return UserSubscriptionResponseDto.from(
                saved
        );
    }

    private void expireExistingSubscriptionIfNecessary(
            UUID userId
    ) {

        UserSubscriptionEntity active =
                subscriptionRepository
                        .findFirstByUserIdAndStatusOrderByCreatedAtDesc(
                                userId,
                                SubscriptionStatus.ACTIVE
                        )
                        .orElse(null);

        if (active == null) {
            return;
        }

        if (active.getExpiresAt() != null &&
                !active.getExpiresAt().isAfter(
                        Instant.now()
                )) {

            active.setStatus(
                    SubscriptionStatus.EXPIRED
            );

            subscriptionRepository.save(
                    active
            );
        }
    }

    private void ensureSubscriptionEligibleUser(
            UserEntity user
    ) {

        if (user.getUserType() != UserType.COMPANY &&
                user.getUserType() != UserType.TRANSPORTER) {

            throw new ResponseStatusException(
                    HttpStatus.FORBIDDEN,
                    "Only company and transporter users can have subscriptions"
            );
        }
    }

    private UUID getCurrentUserId() {

        return SecurityUtils
                .getCurrentUserId()
                .orElseThrow(() ->
                        new ResponseStatusException(
                                HttpStatus.UNAUTHORIZED,
                                "Authentication required"
                        )
                );
    }
}