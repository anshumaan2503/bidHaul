package com.bidhaul.delivery.dto.request;

import jakarta.validation.constraints.DecimalMax;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotNull;
import lombok.*;

import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class RateDeliveryRequestDto {

    @NotNull(message = "Rating is required")
    @DecimalMin(
            value = "0.0",
            message = "Rating cannot be less than 0.0"
    )
    @DecimalMax(
            value = "5.0",
            message = "Rating cannot be greater than 5.0"
    )
    private BigDecimal rating;
}