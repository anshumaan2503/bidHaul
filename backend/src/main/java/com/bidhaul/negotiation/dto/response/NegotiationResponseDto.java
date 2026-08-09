package com.bidhaul.negotiation.dto.response;

import com.bidhaul.negotiation.enums.NegotiationStatus;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.List;
import java.util.UUID;

public record NegotiationResponseDto(

        UUID id,

        UUID tenderId,

        UUID bidId,

        UUID companyId,

        UUID transporterId,

        NegotiationStatus status,

        BigDecimal currentAmount,

        UUID lastOfferedBy,

        BigDecimal finalAmount,

        UUID acceptedBy,

        Instant closedAt,

        Instant createdAt,

        Instant updatedAt,

        List<NegotiationOfferResponseDto> offers

) {
}