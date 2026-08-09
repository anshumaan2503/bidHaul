package com.bidhaul.payment.dto.response;

import java.math.BigDecimal;
import java.util.UUID;

public record PaymentOrderResponseDto(

        UUID paymentId,

        UUID invoiceId,

        String razorpayKeyId,

        String razorpayOrderId,

        BigDecimal amount,

        long amountInPaise,

        String currency,

        String status

) {
}