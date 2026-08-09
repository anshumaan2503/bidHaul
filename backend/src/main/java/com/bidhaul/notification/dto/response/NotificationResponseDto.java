package com.bidhaul.notification.dto.response;

import com.bidhaul.notification.entity.NotificationEntity;
import com.bidhaul.notification.enums.NotificationType;

import java.time.Instant;
import java.util.UUID;

public record NotificationResponseDto(

        UUID id,

        NotificationType type,

        String title,

        String message,

        boolean read,

        Instant readAt,

        String referenceType,

        UUID referenceId,

        Instant createdAt,

        Instant updatedAt

) {

    public static NotificationResponseDto from(
            NotificationEntity notification
    ) {

        return new NotificationResponseDto(
                notification.getId(),
                notification.getType(),
                notification.getTitle(),
                notification.getMessage(),
                notification.isRead(),
                notification.getReadAt(),
                notification.getReferenceType(),
                notification.getReferenceId(),
                notification.getCreatedAt(),
                notification.getUpdatedAt()
        );
    }
}