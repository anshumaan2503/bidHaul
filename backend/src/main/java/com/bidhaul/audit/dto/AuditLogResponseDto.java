package com.bidhaul.audit.dto;

import com.bidhaul.audit.entity.AuditLogEntity;

import java.time.Instant;
import java.util.UUID;

public record AuditLogResponseDto(

        UUID id,

        UUID actorUserId,

        String action,

        String entityType,

        UUID entityId,

        String metadata,

        Instant timestamp

) {

    public static AuditLogResponseDto from(
            AuditLogEntity entity
    ) {

        return new AuditLogResponseDto(
                entity.getId(),
                entity.getActorUserId(),
                entity.getAction(),
                entity.getEntityType(),
                entity.getEntityId(),
                entity.getMetadata(),
                entity.getTimestamp()
        );
    }
}