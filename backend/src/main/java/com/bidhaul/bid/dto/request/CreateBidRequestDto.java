package com.bidhaul.bid.dto.request;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

import java.math.BigDecimal;

public record CreateBidRequestDto(

        @NotNull(message = "Bid amount is required")
        @DecimalMin(
                value = "0.01",
                message = "Bid amount must be greater than zero"
        )
        BigDecimal amount,

        @NotNull(message = "Estimated days is required")
        @Min(
                value = 1,
                message = "Estimated days must be at least 1"
        )
        Integer estimatedDays,

        @NotBlank(message = "Remarks are required")
        String remarks
) {
}