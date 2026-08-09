package com.bidhaul.subscription.dto.request;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.*;

import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CreateSubscriptionPlanRequestDto {

    @NotBlank(message = "Plan name is required")
    private String name;

    @NotNull(message = "Monthly price is required")
    @DecimalMin(
            value = "0.00",
            inclusive = true,
            message = "Monthly price cannot be negative"
    )
    private BigDecimal monthlyPrice;

    @NotBlank(message = "Plan description is required")
    private String description;

    /**
     * JSON array string.
     *
     * Example:
     * ["Tender Management","Reverse Bidding","Analytics"]
     */
    @NotBlank(message = "Features are required")
    private String features;

    private boolean recommended;
}