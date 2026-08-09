package com.bidhaul.audit.aspect;

import com.bidhaul.audit.annotation.AuditLog;
import com.bidhaul.audit.service.AuditLogService;
import com.bidhaul.security.util.SecurityUtils;
import lombok.RequiredArgsConstructor;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.AfterReturning;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.stereotype.Component;

import java.util.UUID;

@Aspect
@Component
@RequiredArgsConstructor
public class AuditLogAspect {

    private final AuditLogService auditLogService;

    @AfterReturning(
            pointcut = "@annotation(com.bidhaul.audit.annotation.AuditLog)",
            returning = "result"
    )
    public void recordAudit(
            JoinPoint joinPoint,
            Object result
    ) {

        MethodSignature signature =
                (MethodSignature) joinPoint.getSignature();

        AuditLog annotation =
                signature
                        .getMethod()
                        .getAnnotation(
                                AuditLog.class
                        );

        UUID actorUserId =
                SecurityUtils
                        .getCurrentUserId()
                        .orElse(null);

        UUID entityId =
                extractEntityId(
                        joinPoint.getArgs()
                );

        String resultType =
                result == null
                        ? "void"
                        : result.getClass().getSimpleName();

        String metadata =
                "{\"method\":\""
                        + signature.getMethod().getName()
                        + "\",\"resultType\":\""
                        + resultType
                        + "\"}";

        auditLogService.record(
                actorUserId,
                annotation.action(),
                annotation.entityType(),
                entityId,
                metadata
        );
    }

    private UUID extractEntityId(
            Object[] args
    ) {

        for (Object arg : args) {

            if (arg instanceof UUID uuid) {
                return uuid;
            }
        }

        return null;
    }
}