package com.bidhaul.negotiation.dto.response;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.UUID;

public record NegotiationOfferResponseDto(

        UUID id,

        UUID offeredBy,

        String offeredByName,

        BigDecimal amount,

        String remarks,

        Instant createdAt

) {
}