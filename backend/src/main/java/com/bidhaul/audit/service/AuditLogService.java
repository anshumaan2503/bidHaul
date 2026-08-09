package com.bidhaul.audit.service;

import com.bidhaul.audit.dto.AuditLogResponseDto;
import com.bidhaul.audit.entity.AuditLogEntity;
import com.bidhaul.audit.repository.AuditLogRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class AuditLogService {

    private final AuditLogRepository auditLogRepository;

    @Transactional
    public void record(
            UUID actorUserId,
            String action,
            String entityType,
            UUID entityId,
            String metadata
    ) {

        auditLogRepository.save(
                AuditLogEntity.builder()
                        .actorUserId(actorUserId)
                        .action(action)
                        .entityType(entityType)
                        .entityId(entityId)
                        .metadata(metadata)
                        .timestamp(Instant.now())
                        .build()
        );
    }

    @Transactional(readOnly = true)
    public Page<AuditLogResponseDto> getAll(
            int page,
            int size
    ) {

        return auditLogRepository
                .findAllByOrderByTimestampDesc(
                        pageable(page, size)
                )
                .map(AuditLogResponseDto::from);
    }

    @Transactional(readOnly = true)
    public Page<AuditLogResponseDto> getByActor(
            UUID actorUserId,
            int page,
            int size
    ) {

        return auditLogRepository
                .findByActorUserIdOrderByTimestampDesc(
                        actorUserId,
                        pageable(page, size)
                )
                .map(AuditLogResponseDto::from);
    }

    @Transactional(readOnly = true)
    public Page<AuditLogResponseDto> getByEntity(
            String entityType,
            UUID entityId,
            int page,
            int size
    ) {

        return auditLogRepository
                .findByEntityTypeAndEntityIdOrderByTimestampDesc(
                        entityType,
                        entityId,
                        pageable(page, size)
                )
                .map(AuditLogResponseDto::from);
    }

    private PageRequest pageable(
            int page,
            int size
    ) {

        int safePage = Math.max(
                page,
                0
        );

        int safeSize = Math.min(
                Math.max(size, 1),
                100
        );

        return PageRequest.of(
                safePage,
                safeSize,
                Sort.by(
                        Sort.Direction.DESC,
                        "timestamp"
                )
        );
    }
}