package com.bidhaul.payment.repository;

import com.bidhaul.payment.entity.PaymentEntity;
import com.bidhaul.payment.enums.PaymentStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

@Repository
public interface PaymentRepository
        extends JpaRepository<PaymentEntity, UUID> {

    Optional<PaymentEntity>
    findTopByInvoiceIdOrderByCreatedAtDesc(
            UUID invoiceId
    );

    Optional<PaymentEntity>
    findByRazorpayOrderId(
            String razorpayOrderId
    );

    Optional<PaymentEntity>
    findByRazorpayPaymentId(
            String razorpayPaymentId
    );

    boolean existsByInvoiceIdAndStatus(
            UUID invoiceId,
            PaymentStatus status
    );
}