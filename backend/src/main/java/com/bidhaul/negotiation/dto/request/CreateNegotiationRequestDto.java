package com.bidhaul.negotiation.dto.request;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

import java.util.UUID;

public record CreateNegotiationRequestDto(

        @NotNull(message = "Bid ID is required")
        UUID bidId,

        @Size(
                max = 1000,
                message = "Remarks must not exceed 1000 characters"
        )
        String remarks

) {
}