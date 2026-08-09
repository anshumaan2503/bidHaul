package com.bidhaul.invoice.dto.response;

import com.bidhaul.invoice.entity.InvoiceEntity;
import com.bidhaul.invoice.enums.InvoiceStatus;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.UUID;

public record InvoiceResponseDto(

        UUID id,

        String invoiceNo,

        UUID userId,

        UUID subscriptionId,

        String planName,

        BigDecimal amount,

        InvoiceStatus status,

        String billingPeriod,

        Instant date,

        Instant dueDate,

        Instant paidAt,

        String paymentOrderReference,

        String paymentReference,

        Instant createdAt,

        Instant updatedAt

) {

    public static InvoiceResponseDto from(
            InvoiceEntity invoice
    ) {

        return new InvoiceResponseDto(
                invoice.getId(),
                invoice.getInvoiceNumber(),
                invoice.getUser().getId(),
                invoice.getSubscription().getId(),
                invoice.getSubscription()
                        .getPlan()
                        .getName(),
                invoice.getAmount(),
                invoice.getStatus(),
                invoice.getBillingPeriod(),
                invoice.getIssuedAt(),
                invoice.getDueAt(),
                invoice.getPaidAt(),
                invoice.getPaymentOrderReference(),
                invoice.getPaymentReference(),
                invoice.getCreatedAt(),
                invoice.getUpdatedAt()
        );
    }
}