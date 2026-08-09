package com.bidhaul.audit.repository;

import com.bidhaul.audit.entity.AuditLogEntity;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface AuditLogRepository
        extends JpaRepository<AuditLogEntity, UUID> {

    Page<AuditLogEntity> findAllByOrderByTimestampDesc(
            Pageable pageable
    );

    Page<AuditLogEntity> findByActorUserIdOrderByTimestampDesc(
            UUID actorUserId,
            Pageable pageable
    );

    Page<AuditLogEntity>
    findByEntityTypeAndEntityIdOrderByTimestampDesc(
            String entityType,
            UUID entityId,
            Pageable pageable
    );
}