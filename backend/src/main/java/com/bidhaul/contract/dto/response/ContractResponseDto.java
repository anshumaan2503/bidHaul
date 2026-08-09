package com.bidhaul.contract.dto.response;

import com.bidhaul.contract.entity.ContractEntity;
import com.bidhaul.contract.enums.ContractStatus;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.UUID;

public record ContractResponseDto(

        UUID id,

        String contractNumber,

        UUID tenderId,

        UUID bidId,

        UUID negotiationId,

        UUID companyId,

        UUID transporterId,

        BigDecimal finalAmount,

        String terms,

        ContractStatus status,

        UUID acceptedBy,

        Instant acceptedAt,

        Instant createdAt,

        Instant updatedAt

) {

    public static ContractResponseDto from(
            ContractEntity contract
    ) {

        return new ContractResponseDto(
                contract.getId(),
                contract.getContractNumber(),
                contract.getTenderId(),
                contract.getBidId(),
                contract.getNegotiationId(),
                contract.getCompany().getId(),
                contract.getTransporter().getId(),
                contract.getFinalAmount(),
                contract.getTerms(),
                contract.getStatus(),
                contract.getAcceptedBy(),
                contract.getAcceptedAt(),
                contract.getCreatedAt(),
                contract.getUpdatedAt()
        );
    }
}