package com.bidhaul.invoice.entity;

import com.bidhaul.common.entity.BaseEntity;
import com.bidhaul.invoice.enums.InvoiceStatus;
import com.bidhaul.subscription.entity.UserSubscriptionEntity;
import com.bidhaul.user.entity.UserEntity;
import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.UUID;

@Entity
@Table(
        name = "invoices",
        uniqueConstraints = {
                @UniqueConstraint(
                        name = "uk_invoices_invoice_number",
                        columnNames = "invoice_number"
                )
        },
        indexes = {
                @Index(
                        name = "idx_invoices_user_id",
                        columnList = "user_id"
                ),
                @Index(
                        name = "idx_invoices_subscription_id",
                        columnList = "subscription_id"
                ),
                @Index(
                        name = "idx_invoices_status",
                        columnList = "status"
                ),
                @Index(
                        name = "idx_invoices_issued_at",
                        columnList = "issued_at"
                )
        }
)
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class InvoiceEntity extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(
            name = "invoice_number",
            nullable = false,
            unique = true,
            length = 40
    )
    private String invoiceNumber;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(
            name = "user_id",
            nullable = false,
            foreignKey = @ForeignKey(
                    name = "fk_invoices_user"
            )
    )
    private UserEntity user;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(
            name = "subscription_id",
            nullable = false,
            foreignKey = @ForeignKey(
                    name = "fk_invoices_subscription"
            )
    )
    private UserSubscriptionEntity subscription;

    @Column(
            nullable = false,
            precision = 12,
            scale = 2
    )
    private BigDecimal amount;

    @Enumerated(EnumType.STRING)
    @Column(
            nullable = false,
            length = 20
    )
    @Builder.Default
    private InvoiceStatus status =
            InvoiceStatus.PENDING;

    @Column(
            name = "billing_period",
            nullable = false,
            length = 20
    )
    private String billingPeriod;

    @Column(
            name = "issued_at",
            nullable = false
    )
    private Instant issuedAt;

    @Column(
            name = "due_at"
    )
    private Instant dueAt;

    @Column(
            name = "paid_at"
    )
    private Instant paidAt;

    /**
     * These fields remain nullable because the actual payment
     * gateway is being implemented separately.
     *
     * The future Razorpay module will populate them after
     * successful order/payment creation.
     */
    @Column(
            name = "payment_order_reference",
            length = 100
    )
    private String paymentOrderReference;

    @Column(
            name = "payment_reference",
            length = 100
    )
    private String paymentReference;
}