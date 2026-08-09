package com.bidhaul.audit.controller;

import com.bidhaul.audit.dto.AuditLogResponseDto;
import com.bidhaul.audit.service.AuditLogService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@RestController
@RequestMapping("/api/v1/admin/audit-logs")
@RequiredArgsConstructor
@PreAuthorize(
        "hasAnyRole('ADMIN', 'SUPER_ADMIN')"
)
public class AuditLogController {

    private final AuditLogService auditLogService;

    @GetMapping
    public ResponseEntity<Page<AuditLogResponseDto>> getAll(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size
    ) {

        return ResponseEntity.ok(
                auditLogService.getAll(
                        page,
                        size
                )
        );
    }

    @GetMapping("/actor/{actorUserId}")
    public ResponseEntity<Page<AuditLogResponseDto>> getByActor(
            @PathVariable UUID actorUserId,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size
    ) {

        return ResponseEntity.ok(
                auditLogService.getByActor(
                        actorUserId,
                        page,
                        size
                )
        );
    }

    @GetMapping("/entity/{entityType}/{entityId}")
    public ResponseEntity<Page<AuditLogResponseDto>> getByEntity(
            @PathVariable String entityType,
            @PathVariable UUID entityId,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size
    ) {

        return ResponseEntity.ok(
                auditLogService.getByEntity(
                        entityType,
                        entityId,
                        page,
                        size
                )
        );
    }
}