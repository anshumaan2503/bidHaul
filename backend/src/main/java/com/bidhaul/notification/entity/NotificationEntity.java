package com.bidhaul.notification.entity;

import com.bidhaul.common.entity.BaseEntity;
import com.bidhaul.notification.enums.NotificationType;
import com.bidhaul.user.entity.UserEntity;
import jakarta.persistence.*;
import lombok.*;

import java.time.Instant;
import java.util.UUID;

@Entity
@Table(
        name = "notifications",
        indexes = {
                @Index(
                        name = "idx_notifications_user_id",
                        columnList = "user_id"
                ),
                @Index(
                        name = "idx_notifications_user_read",
                        columnList = "user_id,is_read"
                ),
                @Index(
                        name = "idx_notifications_created_at",
                        columnList = "created_at"
                ),
                @Index(
                        name = "idx_notifications_reference",
                        columnList = "reference_type,reference_id"
                )
        }
)
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class NotificationEntity extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(
            name = "user_id",
            nullable = false,
            foreignKey = @ForeignKey(
                    name = "fk_notifications_user"
            )
    )
    private UserEntity user;

    @Enumerated(EnumType.STRING)
    @Column(
            nullable = false,
            length = 30
    )
    private NotificationType type;

    @Column(
            nullable = false,
            length = 200
    )
    private String title;

    @Column(
            nullable = false,
            columnDefinition = "TEXT"
    )
    private String message;

    @Column(
            name = "is_read",
            nullable = false
    )
    @Builder.Default
    private boolean read = false;

    @Column(
            name = "read_at"
    )
    private Instant readAt;

    /**
     * Optional business reference.
     *
     * Examples:
     * TENDER + tender UUID
     * BID + bid UUID
     * NEGOTIATION + negotiation UUID
     * CONTRACT + contract UUID
     * DELIVERY + delivery UUID
     */
    @Column(
            name = "reference_type",
            length = 50
    )
    private String referenceType;

    @Column(
            name = "reference_id"
    )
    private UUID referenceId;
}