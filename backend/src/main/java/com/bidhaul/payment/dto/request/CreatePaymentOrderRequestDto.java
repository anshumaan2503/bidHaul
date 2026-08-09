package com.bidhaul.payment.dto.request;

import jakarta.validation.constraints.NotNull;

import java.util.UUID;

public record CreatePaymentOrderRequestDto(

        @NotNull(message = "Invoice ID is required")
        UUID invoiceId

) {
}