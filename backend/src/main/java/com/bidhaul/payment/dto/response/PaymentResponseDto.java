package com.bidhaul.payment.dto.response;

import com.bidhaul.payment.entity.PaymentEntity;
import com.bidhaul.payment.enums.PaymentStatus;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.UUID;

public record PaymentResponseDto(

        UUID paymentId,

        UUID invoiceId,

        String razorpayOrderId,

        String razorpayPaymentId,

        BigDecimal amount,

        String currency,

        PaymentStatus status,

        boolean signatureVerified,

        Instant capturedAt

) {

    public static PaymentResponseDto from(
            PaymentEntity payment
    ) {

        return new PaymentResponseDto(
                payment.getId(),
                payment.getInvoice().getId(),
                payment.getRazorpayOrderId(),
                payment.getRazorpayPaymentId(),
                payment.getAmount(),
                payment.getCurrency(),
                payment.getStatus(),
                payment.isSignatureVerified(),
                payment.getCapturedAt()
        );
    }
}