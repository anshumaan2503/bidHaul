package com.bidhaul.invoice.repository;

import com.bidhaul.invoice.entity.InvoiceEntity;
import com.bidhaul.invoice.enums.InvoiceStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface InvoiceRepository
        extends JpaRepository<InvoiceEntity, UUID> {

    Optional<InvoiceEntity>
    findByInvoiceNumber(String invoiceNumber);

    Optional<InvoiceEntity>
    findBySubscriptionId(UUID subscriptionId);

    List<InvoiceEntity>
    findByUserIdOrderByIssuedAtDesc(UUID userId);

    List<InvoiceEntity>
    findByUserIdAndStatusOrderByIssuedAtDesc(
            UUID userId,
            InvoiceStatus status
    );

    boolean existsBySubscriptionId(UUID subscriptionId);
}