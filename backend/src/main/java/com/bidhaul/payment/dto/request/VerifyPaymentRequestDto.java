package com.bidhaul.payment.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

import java.util.UUID;

public record VerifyPaymentRequestDto(

        @NotNull(message = "Invoice ID is required")
        UUID invoiceId,

        @NotBlank(message = "Razorpay order ID is required")
        String razorpayOrderId,

        @NotBlank(message = "Razorpay payment ID is required")
        String razorpayPaymentId,

        @NotBlank(message = "Razorpay signature is required")
        String razorpaySignature

) {
}