package com.bidhaul.audit.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.Instant;
import java.util.UUID;

@Entity
@Table(
        name = "audit_logs",
        indexes = {
                @Index(
                        name = "idx_audit_logs_actor_user_id",
                        columnList = "actor_user_id"
                ),
                @Index(
                        name = "idx_audit_logs_entity",
                        columnList = "entity_type,entity_id"
                ),
                @Index(
                        name = "idx_audit_logs_timestamp",
                        columnList = "event_timestamp"
                )
        }
)
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AuditLogEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(name = "actor_user_id")
    private UUID actorUserId;

    @Column(nullable = false, length = 80)
    private String action;

    @Column(name = "entity_type", nullable = false, length = 80)
    private String entityType;

    @Column(name = "entity_id")
    private UUID entityId;

    @Column(columnDefinition = "TEXT")
    private String metadata;

    @Column(name = "event_timestamp", nullable = false)
    @Builder.Default
    private Instant timestamp = Instant.now();
}