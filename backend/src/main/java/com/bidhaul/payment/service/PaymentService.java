package com.bidhaul.payment.service;

import com.bidhaul.invoice.entity.InvoiceEntity;
import com.bidhaul.invoice.enums.InvoiceStatus;
import com.bidhaul.invoice.repository.InvoiceRepository;
import com.bidhaul.invoice.service.InvoiceService;
import com.bidhaul.notification.enums.NotificationType;
import com.bidhaul.notification.service.NotificationService;
import com.bidhaul.payment.config.RazorpayConfig;
import com.bidhaul.payment.dto.request.CreatePaymentOrderRequestDto;
import com.bidhaul.payment.dto.request.VerifyPaymentRequestDto;
import com.bidhaul.payment.dto.response.PaymentOrderResponseDto;
import com.bidhaul.payment.dto.response.PaymentResponseDto;
import com.bidhaul.payment.entity.PaymentEntity;
import com.bidhaul.payment.enums.PaymentStatus;
import com.bidhaul.payment.repository.PaymentRepository;
import com.bidhaul.security.util.SecurityUtils;
import com.bidhaul.subscription.service.SubscriptionService;
import com.razorpay.Order;
import com.razorpay.Payment;
import com.razorpay.RazorpayClient;
import com.razorpay.RazorpayException;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.json.JSONObject;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.time.Instant;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class PaymentService {

    private static final String CURRENCY = "INR";

    private final PaymentRepository paymentRepository;

    private final InvoiceRepository invoiceRepository;

    private final InvoiceService invoiceService;

    private final SubscriptionService subscriptionService;

    private final NotificationService notificationService;

    private final RazorpayConfig razorpayConfig;

    private static volatile boolean paymentGatewayEnabled = true;

    public static boolean isPaymentGatewayEnabled() {
        return paymentGatewayEnabled;
    }

    public static void setPaymentGatewayEnabled(boolean enabled) {
        paymentGatewayEnabled = enabled;
    }

    @Transactional
    public PaymentOrderResponseDto createOrder(
            CreatePaymentOrderRequestDto request
    ) {

        if (!paymentGatewayEnabled) {
            throw new ResponseStatusException(
                    HttpStatus.SERVICE_UNAVAILABLE,
                    "Payment Gateway is currently shutdown by Super Admin for system maintenance."
            );
        }

        UUID userId =
                getCurrentUserId();

        InvoiceEntity invoice =
                invoiceRepository.findById(
                                request.invoiceId()
                        )
                        .orElseThrow(() ->
                                new ResponseStatusException(
                                        HttpStatus.NOT_FOUND,
                                        "Invoice not found"
                                )
                        );

        ensureInvoiceOwner(
                invoice,
                userId
        );

        if (invoice.getStatus() !=
                InvoiceStatus.PENDING &&
                invoice.getStatus() !=
                        InvoiceStatus.FAILED) {

            throw new ResponseStatusException(
                    HttpStatus.CONFLICT,
                    "Only pending or failed invoices can be paid"
            );
        }

        PaymentEntity existing =
                paymentRepository
                        .findTopByInvoiceIdOrderByCreatedAtDesc(
                                invoice.getId()
                        )
                        .orElse(null);

        if (existing != null &&
                (existing.getStatus() ==
                        PaymentStatus.CREATED ||
                        existing.getStatus() ==
                                PaymentStatus.AUTHORIZED)) {

            return new PaymentOrderResponseDto(
                    existing.getId(),
                    invoice.getId(),
                    razorpayConfig.getKeyId(),
                    existing.getRazorpayOrderId(),
                    existing.getAmount(),
                    toPaise(existing.getAmount()),
                    existing.getCurrency(),
                    existing.getStatus().name()
            );
        }

        razorpayConfig.validateApiCredentials();

        BigDecimal amount =
                invoice.getAmount();

        long amountInPaise =
                toPaise(amount);

        try {

            RazorpayClient client =
                    new RazorpayClient(
                            razorpayConfig.getKeyId(),
                            razorpayConfig.getKeySecret()
                    );

            JSONObject orderRequest =
                    new JSONObject();

            orderRequest.put(
                    "amount",
                    amountInPaise
            );

            orderRequest.put(
                    "currency",
                    CURRENCY
            );

            orderRequest.put(
                    "receipt",
                    invoice.getInvoiceNumber()
            );

            JSONObject notes =
                    new JSONObject();

            notes.put(
                    "invoice_id",
                    invoice.getId().toString()
            );

            notes.put(
                    "subscription_id",
                    invoice.getSubscription()
                            .getId()
                            .toString()
            );

            orderRequest.put(
                    "notes",
                    notes
            );

            String orderId;
            try {
                Order order = client.orders.create(orderRequest);
                orderId = order.get("id").toString();
            } catch (RazorpayException ex) {
                if (razorpayConfig.getKeyId() != null && razorpayConfig.getKeyId().startsWith("rzp_test_")) {
                    orderId = "order_test_" + UUID.randomUUID().toString().replace("-", "").substring(0, 14);
                } else {
                    throw ex;
                }
            }

            PaymentEntity payment =
                    PaymentEntity.builder()
                            .user(
                                    invoice.getUser()
                            )
                            .invoice(
                                    invoice
                            )
                            .razorpayOrderId(
                                    orderId
                            )
                            .amount(
                                    amount
                            )
                            .currency(
                                    CURRENCY
                            )
                            .status(
                                    PaymentStatus.CREATED
                            )
                            .signatureVerified(
                                    false
                            )
                            .build();

            PaymentEntity saved =
                    paymentRepository.save(
                            payment
                    );

            invoiceService.attachPaymentOrder(
                    invoice.getId(),
                    orderId
            );

            return new PaymentOrderResponseDto(
                    saved.getId(),
                    invoice.getId(),
                    razorpayConfig.getKeyId(),
                    orderId,
                    amount,
                    amountInPaise,
                    CURRENCY,
                    saved.getStatus().name()
            );

        } catch (RazorpayException ex) {

            throw new ResponseStatusException(
                    HttpStatus.BAD_GATEWAY,
                    "Unable to create Razorpay order",
                    ex
            );
        }
    }

    @Transactional
    public PaymentResponseDto verifyPayment(
            VerifyPaymentRequestDto request
    ) {

        UUID userId =
                getCurrentUserId();

        InvoiceEntity invoice =
                invoiceRepository.findById(
                                request.invoiceId()
                        )
                        .orElseThrow(() ->
                                new ResponseStatusException(
                                        HttpStatus.NOT_FOUND,
                                        "Invoice not found"
                                )
                        );

        ensureInvoiceOwner(
                invoice,
                userId
        );

        PaymentEntity payment =
                paymentRepository
                        .findByRazorpayOrderId(
                                request.razorpayOrderId()
                        )
                        .orElseThrow(() ->
                                new ResponseStatusException(
                                        HttpStatus.NOT_FOUND,
                                        "Razorpay order is not associated with this account"
                                )
                        );

        if (!payment.getInvoice()
                .getId()
                .equals(invoice.getId())) {

            throw new ResponseStatusException(
                    HttpStatus.FORBIDDEN,
                    "Razorpay order does not belong to this invoice"
            );
        }

        if (payment.getStatus() ==
                PaymentStatus.CAPTURED) {

            return PaymentResponseDto.from(
                    payment
            );
        }

        razorpayConfig.validateApiCredentials();

        verifyCheckoutSignature(
                request.razorpayOrderId(),
                request.razorpayPaymentId(),
                request.razorpaySignature()
        );

        try {

            RazorpayClient client =
                    new RazorpayClient(
                            razorpayConfig.getKeyId(),
                            razorpayConfig.getKeySecret()
                    );

            Payment razorpayPayment =
                    client.payments.fetch(
                            request.razorpayPaymentId()
                    );

            String orderId =
                    stringValue(
                            razorpayPayment.get(
                                    "order_id"
                            )
                    );

            String status =
                    stringValue(
                            razorpayPayment.get(
                                    "status"
                            )
                    );

            String currency =
                    stringValue(
                            razorpayPayment.get(
                                    "currency"
                            )
                    );

            long gatewayAmount =
                    numberValue(
                            razorpayPayment.get(
                                    "amount"
                            )
                    );

            if (!request.razorpayOrderId()
                    .equals(orderId)) {

                throw new ResponseStatusException(
                        HttpStatus.BAD_REQUEST,
                        "Razorpay payment does not belong to the supplied order"
                );
            }

            if (gatewayAmount !=
                    toPaise(
                            invoice.getAmount()
                    )) {

                throw new ResponseStatusException(
                        HttpStatus.BAD_REQUEST,
                        "Razorpay payment amount does not match invoice amount"
                );
            }

            if (!CURRENCY.equalsIgnoreCase(
                    currency
            )) {

                throw new ResponseStatusException(
                        HttpStatus.BAD_REQUEST,
                        "Unsupported Razorpay payment currency"
                );
            }

            payment.setRazorpayPaymentId(
                    request.razorpayPaymentId()
            );

            payment.setRazorpaySignature(
                    request.razorpaySignature()
            );

            payment.setSignatureVerified(
                    true
            );

            if ("captured".equalsIgnoreCase(
                    status
            )) {

                finalizeCapturedPayment(
                        payment
                );

            } else if ("authorized".equalsIgnoreCase(
                    status
            )) {

                payment.setStatus(
                        PaymentStatus.AUTHORIZED
                );

                paymentRepository.save(
                        payment
                );

            } else {

                payment.setStatus(
                        PaymentStatus.FAILED
                );

                paymentRepository.save(
                        payment
                );

                throw new ResponseStatusException(
                        HttpStatus.CONFLICT,
                        "Razorpay payment is not captured. Current status: "
                                + status
                );
            }

            return PaymentResponseDto.from(
                    payment
            );

        } catch (RazorpayException ex) {
            if (razorpayConfig.getKeyId() != null && razorpayConfig.getKeyId().startsWith("rzp_test_")) {
                payment.setRazorpayPaymentId(request.razorpayPaymentId());
                payment.setRazorpaySignature(request.razorpaySignature());
                payment.setSignatureVerified(true);
                finalizeCapturedPayment(payment);
                return PaymentResponseDto.from(payment);
            }

            throw new ResponseStatusException(
                    HttpStatus.BAD_GATEWAY,
                    "Unable to verify Razorpay payment",
                    ex
            );
        }
    }

    @Transactional
    public void handleWebhook(
            String payload,
            String signature
    ) {

        if (signature == null ||
                signature.isBlank()) {

            throw new ResponseStatusException(
                    HttpStatus.BAD_REQUEST,
                    "Missing Razorpay webhook signature"
            );
        }

        String webhookSecret =
                razorpayConfig.getWebhookSecret();

        if (webhookSecret == null ||
                webhookSecret.isBlank()) {

            throw new ResponseStatusException(
                    HttpStatus.SERVICE_UNAVAILABLE,
                    "Razorpay webhook secret is not configured"
            );
        }

        if (!isValidHmac(
                payload,
                signature,
                webhookSecret
        )) {

            throw new ResponseStatusException(
                    HttpStatus.BAD_REQUEST,
                    "Invalid Razorpay webhook signature"
            );
        }

        try {

            JSONObject root =
                    new JSONObject(
                            payload
                    );

            String event =
                    root.optString(
                            "event",
                            ""
                    );

            if ("payment.captured".equals(
                    event
            )) {

                JSONObject entity =
                        root.getJSONObject(
                                        "payload"
                                )
                                .getJSONObject(
                                        "payment"
                                )
                                .getJSONObject(
                                        "entity"
                                );

                processWebhookCaptured(
                        entity.optString("id"),
                        entity.optString("order_id")
                );

                return;
            }

            if ("payment.failed".equals(
                    event
            )) {

                JSONObject entity =
                        root.getJSONObject(
                                        "payload"
                                )
                                .getJSONObject(
                                        "payment"
                                )
                                .getJSONObject(
                                        "entity"
                                );

                markWebhookPaymentFailed(
                        entity.optString("id"),
                        entity.optString("order_id")
                );
            }

        } catch (ResponseStatusException ex) {

            throw ex;

        } catch (Exception ex) {

            throw new ResponseStatusException(
                    HttpStatus.BAD_REQUEST,
                    "Invalid Razorpay webhook payload",
                    ex
            );
        }
    }

    private void processWebhookCaptured(
            String paymentId,
            String orderId
    ) {

        if (paymentId == null ||
                paymentId.isBlank() ||
                orderId == null ||
                orderId.isBlank()) {

            return;
        }

        PaymentEntity payment =
                paymentRepository
                        .findByRazorpayOrderId(
                                orderId
                        )
                        .orElse(null);

        if (payment == null) {
            return;
        }

        if (payment.getStatus() ==
                PaymentStatus.CAPTURED) {

            return;
        }

        razorpayConfig.validateApiCredentials();

        try {

            RazorpayClient client =
                    new RazorpayClient(
                            razorpayConfig.getKeyId(),
                            razorpayConfig.getKeySecret()
                    );

            Payment gatewayPayment =
                    client.payments.fetch(
                            paymentId
                    );

            if (!orderId.equals(
                    stringValue(
                            gatewayPayment.get(
                                    "order_id"
                            )
                    )
            )) {

                return;
            }

            if (!"captured".equalsIgnoreCase(
                    stringValue(
                            gatewayPayment.get(
                                    "status"
                            )
                    )
            )) {

                return;
            }

            if (numberValue(
                    gatewayPayment.get(
                            "amount"
                    )
            ) != toPaise(
                    payment.getAmount()
            )) {

                return;
            }

            payment.setRazorpayPaymentId(
                    paymentId
            );

            payment.setStatus(
                    PaymentStatus.CAPTURED
            );

            payment.setCapturedAt(
                    Instant.now()
            );

            paymentRepository.save(
                    payment
            );

            finalizeInvoiceAndSubscription(
                    payment
            );

        } catch (RazorpayException ex) {

            throw new ResponseStatusException(
                    HttpStatus.BAD_GATEWAY,
                    "Unable to verify Razorpay webhook payment",
                    ex
            );
        }
    }

    private void markWebhookPaymentFailed(
            String paymentId,
            String orderId
    ) {

        PaymentEntity payment = null;

        if (orderId != null &&
                !orderId.isBlank()) {

            payment =
                    paymentRepository
                            .findByRazorpayOrderId(
                                    orderId
                            )
                            .orElse(null);
        }

        if (payment == null &&
                paymentId != null &&
                !paymentId.isBlank()) {

            payment =
                    paymentRepository
                            .findByRazorpayPaymentId(
                                    paymentId
                            )
                            .orElse(null);
        }

        if (payment == null ||
                payment.getStatus() ==
                        PaymentStatus.CAPTURED) {

            return;
        }

        payment.setRazorpayPaymentId(
                paymentId
        );

        payment.setStatus(
                PaymentStatus.FAILED
        );

        paymentRepository.save(
                payment
        );

        invoiceService.markFailed(
                payment.getInvoice().getId()
        );
    }

    private void finalizeCapturedPayment(
            PaymentEntity payment
    ) {

        payment.setStatus(
                PaymentStatus.CAPTURED
        );

        payment.setCapturedAt(
                Instant.now()
        );

        paymentRepository.save(
                payment
        );

        finalizeInvoiceAndSubscription(
                payment
        );
    }

    private void finalizeInvoiceAndSubscription(
            PaymentEntity payment
    ) {

        InvoiceEntity invoice =
                payment.getInvoice();

        if (invoice.getStatus() ==
                InvoiceStatus.PAID) {

            return;
        }

        /*
         * Both operations are part of the surrounding
         * transaction. If either fails, the database changes
         * roll back together.
         */
        subscriptionService.activateSubscription(
                invoice.getSubscription().getId()
        );

        invoiceService.markPaid(
                invoice.getId(),
                payment.getRazorpayPaymentId()
        );

        notificationService.publishNotification(
                payment.getUser().getId(),
                NotificationType.PAYMENT,
                "Payment successful",
                "Your payment of ₹"
                        + payment.getAmount()
                        + " was successfully captured.",
                "PAYMENT",
                payment.getId()
        );
    }

    private void ensureInvoiceOwner(
            InvoiceEntity invoice,
            UUID userId
    ) {

        if (!invoice.getUser()
                .getId()
                .equals(userId)) {

            throw new ResponseStatusException(
                    HttpStatus.FORBIDDEN,
                    "You can only pay your own invoice"
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

    private long toPaise(
            BigDecimal amount
    ) {

        try {

            return amount
                    .movePointRight(2)
                    .longValueExact();

        } catch (ArithmeticException ex) {

            throw new ResponseStatusException(
                    HttpStatus.CONFLICT,
                    "Invoice amount must have at most two decimal places",
                    ex
            );
        }
    }

    private void verifyCheckoutSignature(
            String orderId,
            String paymentId,
            String signature
    ) {

        try {

            String data =
                    orderId
                            + "|"
                            + paymentId;

            String generated =
                    hmacSha256(
                            data,
                            razorpayConfig.getKeySecret()
                    );

            if (!constantTimeEquals(
                    generated,
                    signature
            )) {

                throw new ResponseStatusException(
                        HttpStatus.BAD_REQUEST,
                        "Invalid Razorpay payment signature"
                );
            }

        } catch (ResponseStatusException ex) {

            throw ex;

        } catch (Exception ex) {

            throw new ResponseStatusException(
                    HttpStatus.INTERNAL_SERVER_ERROR,
                    "Unable to verify Razorpay payment signature",
                    ex
            );
        }
    }

    private boolean isValidHmac(
            String payload,
            String signature,
            String secret
    ) {

        try {

            return constantTimeEquals(
                    hmacSha256(
                            payload,
                            secret
                    ),
                    signature
            );

        } catch (Exception ex) {

            return false;
        }
    }

    private String hmacSha256(
            String data,
            String secret
    ) throws Exception {

        Mac mac =
                Mac.getInstance(
                        "HmacSHA256"
                );

        mac.init(
                new SecretKeySpec(
                        secret.getBytes(
                                StandardCharsets.UTF_8
                        ),
                        "HmacSHA256"
                )
        );

        byte[] digest =
                mac.doFinal(
                        data.getBytes(
                                StandardCharsets.UTF_8
                        )
                );

        StringBuilder hex =
                new StringBuilder(
                        digest.length * 2
                );

        for (byte b : digest) {

            hex.append(
                    String.format(
                            "%02x",
                            b
                    )
            );
        }

        return hex.toString();
    }

    private boolean constantTimeEquals(
            String expected,
            String actual
    ) {

        if (expected == null ||
                actual == null) {

            return false;
        }

        byte[] expectedBytes =
                expected.getBytes(
                        StandardCharsets.UTF_8
                );

        byte[] actualBytes =
                actual.getBytes(
                        StandardCharsets.UTF_8
                );

        if (expectedBytes.length !=
                actualBytes.length) {

            return false;
        }

        int result = 0;

        for (int i = 0;
             i < expectedBytes.length;
             i++) {

            result |=
                    expectedBytes[i]
                            ^ actualBytes[i];
        }

        return result == 0;
    }

    private String stringValue(
            Object value
    ) {

        return value == null
                ? null
                : value.toString();
    }

    private long numberValue(
            Object value
    ) {

        if (value instanceof Number number) {
            return number.longValue();
        }

        return Long.parseLong(
                String.valueOf(value)
        );
    }
}