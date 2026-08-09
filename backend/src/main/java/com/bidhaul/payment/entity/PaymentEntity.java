package com.bidhaul.payment.entity;

import com.bidhaul.common.entity.BaseEntity;
import com.bidhaul.invoice.entity.InvoiceEntity;
import com.bidhaul.payment.enums.PaymentStatus;
import com.bidhaul.user.entity.UserEntity;
import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.UUID;

@Entity
@Table(
        name = "payments",
        indexes = {
                @Index(
                        name = "idx_payments_user_id",
                        columnList = "user_id"
                ),
                @Index(
                        name = "idx_payments_invoice_id",
                        columnList = "invoice_id"
                ),
                @Index(
                        name = "idx_payments_status",
                        columnList = "status"
                ),
                @Index(
                        name = "idx_payments_created_at",
                        columnList = "created_at"
                )
        },
        uniqueConstraints = {
                @UniqueConstraint(
                        name = "uk_payments_razorpay_order_id",
                        columnNames = "razorpay_order_id"
                ),
                @UniqueConstraint(
                        name = "uk_payments_razorpay_payment_id",
                        columnNames = "razorpay_payment_id"
                )
        }
)
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PaymentEntity extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(
            name = "user_id",
            nullable = false,
            foreignKey = @ForeignKey(
                    name = "fk_payments_user"
            )
    )
    private UserEntity user;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(
            name = "invoice_id",
            nullable = false,
            foreignKey = @ForeignKey(
                    name = "fk_payments_invoice"
            )
    )
    private InvoiceEntity invoice;

    @Column(
            name = "razorpay_order_id",
            nullable = false,
            length = 100
    )
    private String razorpayOrderId;

    @Column(
            name = "razorpay_payment_id",
            length = 100
    )
    private String razorpayPaymentId;

    @Column(
            nullable = false,
            precision = 12,
            scale = 2
    )
    private BigDecimal amount;

    @Column(
            nullable = false,
            length = 3
    )
    private String currency;

    @Enumerated(EnumType.STRING)
    @Column(
            nullable = false,
            length = 30
    )
    @Builder.Default
    private PaymentStatus status =
            PaymentStatus.CREATED;

    @Column(
            name = "razorpay_signature",
            length = 128
    )
    private String razorpaySignature;

    @Column(
            name = "signature_verified",
            nullable = false
    )
    @Builder.Default
    private boolean signatureVerified = false;

    @Column(
            name = "captured_at"
    )
    private Instant capturedAt;
}