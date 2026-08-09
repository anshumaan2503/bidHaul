package com.bidhaul.notification.event;

import com.bidhaul.notification.enums.NotificationType;

import java.util.UUID;

public record NotificationEvent(

        UUID targetUserId,

        NotificationType type,

        String title,

        String message,

        String referenceType,

        UUID referenceId

) {

    public NotificationEvent {

        if (targetUserId == null) {
            throw new IllegalArgumentException(
                    "Notification target user ID is required"
            );
        }

        if (type == null) {
            throw new IllegalArgumentException(
                    "Notification type is required"
            );
        }

        if (title == null || title.isBlank()) {
            throw new IllegalArgumentException(
                    "Notification title is required"
            );
        }

        if (message == null || message.isBlank()) {
            throw new IllegalArgumentException(
                    "Notification message is required"
            );
        }
    }
}