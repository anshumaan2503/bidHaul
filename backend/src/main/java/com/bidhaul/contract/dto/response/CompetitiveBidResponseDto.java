package com.bidhaul.contract.dto.response;

import com.bidhaul.negotiation.enums.NegotiationStatus;

import java.math.BigDecimal;
import java.util.UUID;

public record CompetitiveBidResponseDto(

        int rank,

        UUID bidId,

        String bidNumber,

        UUID transporterId,

        String transporterName,

        BigDecimal initialBidAmount,

        BigDecimal currentNegotiationAmount,

        BigDecimal finalNegotiatedAmount,

        BigDecimal savingsAmount,

        NegotiationStatus negotiationStatus
) {
}