package com.bidhaul.tender.dto.request;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

import java.math.BigDecimal;

public record CreateTenderRequestDto(

        @NotBlank(message = "Title is required")
        String title,

        @NotBlank(message = "Description is required")
        String description,

        @NotBlank(message = "Pickup location is required")
        String pickupLocation,

        @NotBlank(message = "Delivery location is required")
        String deliveryLocation,

        @NotBlank(message = "Material type is required")
        String materialType,

        @NotBlank(message = "Vehicle type is required")
        String vehicleType,

        @NotNull(message = "Weight is required")
        @DecimalMin(value = "0.01", message = "Weight must be greater than zero")
        BigDecimal weightTons,

        @NotNull(message = "Budget is required")
        @DecimalMin(value = "0.01", message = "Budget must be greater than zero")
        BigDecimal ceilingBudget
) {
}