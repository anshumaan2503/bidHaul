package com.bidhaul.negotiation.dto.request;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

import java.math.BigDecimal;

public record CreateNegotiationOfferRequestDto(

        @NotNull(message = "Offer amount is required")
        @DecimalMin(
                value = "0.01",
                message = "Offer amount must be greater than zero"
        )
        BigDecimal amount,

        @NotBlank(message = "Remarks are required")
        @Size(
                max = 1000,
                message = "Remarks must not exceed 1000 characters"
        )
        String remarks

) {
}