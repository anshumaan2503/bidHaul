package com.bidhaul.invoice.service;

import com.bidhaul.invoice.dto.response.InvoiceResponseDto;
import com.bidhaul.invoice.entity.InvoiceEntity;
import com.bidhaul.invoice.enums.InvoiceStatus;
import com.bidhaul.invoice.repository.InvoiceRepository;
import com.bidhaul.security.util.SecurityUtils;
import com.bidhaul.subscription.entity.UserSubscriptionEntity;
import com.bidhaul.subscription.enums.BillingCycle;
import com.bidhaul.subscription.enums.SubscriptionStatus;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.List;
import java.util.UUID;

@Service
public class InvoiceService {

    private final InvoiceRepository invoiceRepository;

    public InvoiceService(
            InvoiceRepository invoiceRepository
    ) {
        this.invoiceRepository = invoiceRepository;
    }

    /**
     * Creates the invoice associated with a newly-created
     * subscription.
     *
     * The invoice starts as PENDING because payment is handled
     * by the separate Razorpay module.
     */
    @Transactional
    public InvoiceEntity createPendingInvoice(
            UserSubscriptionEntity subscription
    ) {

        if (subscription == null) {
            throw new ResponseStatusException(
                    HttpStatus.BAD_REQUEST,
                    "Subscription is required"
            );
        }

        if (invoiceRepository.existsBySubscriptionId(
                subscription.getId()
        )) {

            throw new ResponseStatusException(
                    HttpStatus.CONFLICT,
                    "An invoice already exists for this subscription"
            );
        }

        BigDecimal amount =
                subscription.getPriceAtSubscription();

        if (amount == null ||
                amount.compareTo(BigDecimal.ZERO) < 0) {

            throw new ResponseStatusException(
                    HttpStatus.CONFLICT,
                    "Subscription does not contain a valid invoice amount"
            );
        }

        Instant issuedAt = Instant.now();

        Instant dueAt =
                issuedAt.plus(
                        7,
                        ChronoUnit.DAYS
                );

        InvoiceEntity invoice =
                InvoiceEntity.builder()
                        .invoiceNumber(
                                generateInvoiceNumber()
                        )
                        .user(
                                subscription.getUser()
                        )
                        .subscription(
                                subscription
                        )
                        .amount(amount)
                        .status(
                                InvoiceStatus.PENDING
                        )
                        .billingPeriod(
                                billingPeriod(
                                        subscription
                                                .getBillingCycle()
                                )
                        )
                        .issuedAt(issuedAt)
                        .dueAt(dueAt)
                        .build();

        return invoiceRepository.save(invoice);
    }

    @Transactional(readOnly = true)
    public InvoiceResponseDto getInvoice(
            UUID invoiceId
    ) {

        UUID userId = getCurrentUserId();

        InvoiceEntity invoice =
                findInvoice(invoiceId);

        ensureOwner(
                invoice,
                userId
        );

        return InvoiceResponseDto.from(
                invoice
        );
    }

    @Transactional(readOnly = true)
    public InvoiceResponseDto getSubscriptionInvoice(
            UUID subscriptionId
    ) {

        UUID userId = getCurrentUserId();

        InvoiceEntity invoice =
                invoiceRepository
                        .findBySubscriptionId(
                                subscriptionId
                        )
                        .orElseThrow(() ->
                                new ResponseStatusException(
                                        HttpStatus.NOT_FOUND,
                                        "Invoice not found for subscription"
                                )
                        );

        ensureOwner(
                invoice,
                userId
        );

        return InvoiceResponseDto.from(
                invoice
        );
    }

    @Transactional(readOnly = true)
    public List<InvoiceResponseDto> getMyInvoices() {

        UUID userId = getCurrentUserId();

        return invoiceRepository
                .findByUserIdOrderByIssuedAtDesc(userId)
                .stream()
                .map(InvoiceResponseDto::from)
                .toList();
    }

    /**
     * Future Razorpay integration will use this method after
     * successful order creation.
     *
     * It intentionally does not mark the invoice paid.
     */
    @Transactional
    public InvoiceResponseDto attachPaymentOrder(
            UUID invoiceId,
            String paymentOrderReference
    ) {

        if (paymentOrderReference == null ||
                paymentOrderReference.isBlank()) {

            throw new ResponseStatusException(
                    HttpStatus.BAD_REQUEST,
                    "Payment order reference is required"
            );
        }

        InvoiceEntity invoice =
                findInvoice(invoiceId);

        if (invoice.getStatus() ==
                InvoiceStatus.CANCELLED) {

            throw new ResponseStatusException(
                    HttpStatus.CONFLICT,
                    "Cancelled invoice cannot receive a payment order"
            );
        }

        invoice.setPaymentOrderReference(
                paymentOrderReference.trim()
        );

        return InvoiceResponseDto.from(
                invoiceRepository.save(invoice)
        );
    }

    /**
     * Future Razorpay verification will use this method
     * after the backend verifies the Razorpay signature.
     */
    @Transactional
    public InvoiceResponseDto markPaid(
            UUID invoiceId,
            String paymentReference
    ) {

        if (paymentReference == null ||
                paymentReference.isBlank()) {

            throw new ResponseStatusException(
                    HttpStatus.BAD_REQUEST,
                    "Payment reference is required"
            );
        }

        InvoiceEntity invoice =
                findInvoice(invoiceId);

        if (invoice.getStatus() ==
                InvoiceStatus.PAID) {

            return InvoiceResponseDto.from(
                    invoice
            );
        }

        if (invoice.getStatus() ==
                InvoiceStatus.CANCELLED) {

            throw new ResponseStatusException(
                    HttpStatus.CONFLICT,
                    "Cancelled invoice cannot be marked as paid"
            );
        }

        invoice.setStatus(
                InvoiceStatus.PAID
        );

        invoice.setPaymentReference(
                paymentReference.trim()
        );

        invoice.setPaidAt(
                Instant.now()
        );

        return InvoiceResponseDto.from(
                invoiceRepository.save(invoice)
        );
    }

    /**
     * Future Razorpay failure handling can use this method.
     */
    @Transactional
    public InvoiceResponseDto markFailed(
            UUID invoiceId
    ) {

        InvoiceEntity invoice =
                findInvoice(invoiceId);

        if (invoice.getStatus() ==
                InvoiceStatus.PAID) {

            throw new ResponseStatusException(
                    HttpStatus.CONFLICT,
                    "A paid invoice cannot be marked as failed"
            );
        }

        if (invoice.getStatus() ==
                InvoiceStatus.CANCELLED) {

            throw new ResponseStatusException(
                    HttpStatus.CONFLICT,
                    "Invoice is already cancelled"
            );
        }

        invoice.setStatus(
                InvoiceStatus.FAILED
        );

        return InvoiceResponseDto.from(
                invoiceRepository.save(invoice)
        );
    }

    @Transactional
    public InvoiceResponseDto cancelInvoice(
            UUID invoiceId
    ) {

        UUID userId = getCurrentUserId();

        InvoiceEntity invoice =
                findInvoice(invoiceId);

        ensureOwner(
                invoice,
                userId
        );

        if (invoice.getStatus() ==
                InvoiceStatus.PAID) {

            throw new ResponseStatusException(
                    HttpStatus.CONFLICT,
                    "Paid invoice cannot be cancelled"
            );
        }

        invoice.setStatus(
                InvoiceStatus.CANCELLED
        );

        return InvoiceResponseDto.from(
                invoiceRepository.save(invoice)
        );
    }

    private InvoiceEntity findInvoice(
            UUID invoiceId
    ) {

        return invoiceRepository.findById(
                        invoiceId
                )
                .orElseThrow(() ->
                        new ResponseStatusException(
                                HttpStatus.NOT_FOUND,
                                "Invoice not found"
                        )
                );
    }

    private void ensureOwner(
            InvoiceEntity invoice,
            UUID userId
    ) {

        if (!invoice.getUser()
                .getId()
                .equals(userId)) {

            throw new ResponseStatusException(
                    HttpStatus.FORBIDDEN,
                    "You can only access your own invoices"
            );
        }
    }

    private UUID getCurrentUserId() {

        return SecurityUtils.getCurrentUserId()
                .orElseThrow(() ->
                        new ResponseStatusException(
                                HttpStatus.UNAUTHORIZED,
                                "Authentication required"
                        )
                );
    }

    private String billingPeriod(
            BillingCycle billingCycle
    ) {

        if (billingCycle == BillingCycle.ANNUAL) {
            return "Annual";
        }

        return "Monthly";
    }

    private String generateInvoiceNumber() {

        String timestamp =
                String.valueOf(
                        System.currentTimeMillis()
                );

        String suffix =
                UUID.randomUUID()
                        .toString()
                        .replace("-", "")
                        .substring(0, 6)
                        .toUpperCase();

        return "INV-" + timestamp + "-" + suffix;
    }
}