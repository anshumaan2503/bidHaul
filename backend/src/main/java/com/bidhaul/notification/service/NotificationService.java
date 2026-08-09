package com.bidhaul.notification.service;

import com.bidhaul.notification.dto.response.NotificationResponseDto;
import com.bidhaul.notification.entity.NotificationEntity;
import com.bidhaul.notification.event.NotificationEvent;
import com.bidhaul.notification.enums.NotificationType;
import com.bidhaul.notification.repository.NotificationRepository;
import com.bidhaul.security.util.SecurityUtils;
import com.bidhaul.user.entity.UserEntity;
import com.bidhaul.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.http.HttpStatus;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;

import java.time.Instant;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class NotificationService {

    private final NotificationRepository notificationRepository;

    private final UserRepository userRepository;

    private final ApplicationEventPublisher eventPublisher;

    /**
     * Publishes an application event.
     *
     * Existing/future business modules should call this method
     * after completing their business operation.
     */
    public void publishNotification(
            UUID targetUserId,
            NotificationType type,
            String title,
            String message,
            String referenceType,
            UUID referenceId
    ) {

        eventPublisher.publishEvent(
                new NotificationEvent(
                        targetUserId,
                        type,
                        title,
                        message,
                        referenceType,
                        referenceId
                )
        );
    }

    /**
     * Async event listener.
     *
     * The business operation that generated the event is not
     * blocked by notification persistence.
     */
    @Async("notificationTaskExecutor")
    @Transactional
    @org.springframework.context.event.EventListener
    public void handleNotificationEvent(
            NotificationEvent event
    ) {

        UserEntity user =
                userRepository.findById(
                                event.targetUserId()
                        )
                        .orElse(null);

        /*
         * The target user may have been deleted/suspended
         * between event publication and asynchronous processing.
         *
         * In that case there is no valid notification recipient,
         * so simply ignore the event.
         */
        if (user == null) {
            return;
        }

        NotificationEntity notification =
                NotificationEntity.builder()
                        .user(user)
                        .type(event.type())
                        .title(event.title().trim())
                        .message(event.message().trim())
                        .read(false)
                        .referenceType(
                                normalizeReferenceType(
                                        event.referenceType()
                                )
                        )
                        .referenceId(
                                event.referenceId()
                        )
                        .build();

        notificationRepository.save(
                notification
        );
    }

    @Transactional
    public NotificationResponseDto createNotification(
            UUID targetUserId,
            NotificationType type,
            String title,
            String message,
            String referenceType,
            UUID referenceId
    ) {

        UserEntity user =
                userRepository.findById(
                                targetUserId
                        )
                        .orElseThrow(() ->
                                new ResponseStatusException(
                                        HttpStatus.NOT_FOUND,
                                        "Notification target user not found"
                                )
                        );

        NotificationEntity notification =
                NotificationEntity.builder()
                        .user(user)
                        .type(type)
                        .title(title.trim())
                        .message(message.trim())
                        .read(false)
                        .referenceType(
                                normalizeReferenceType(
                                        referenceType
                                )
                        )
                        .referenceId(referenceId)
                        .build();

        return NotificationResponseDto.from(
                notificationRepository.save(
                        notification
                )
        );
    }

    @Transactional(readOnly = true)
    public Page<NotificationResponseDto> getMyNotifications(
            int page,
            int size
    ) {

        UUID userId =
                getCurrentUserId();

        PageRequest pageable =
                PageRequest.of(
                        normalizePage(page),
                        normalizeSize(size),
                        Sort.by(
                                Sort.Direction.DESC,
                                "createdAt"
                        )
                );

        return notificationRepository
                .findByUserIdOrderByCreatedAtDesc(
                        userId,
                        pageable
                )
                .map(
                        NotificationResponseDto::from
                );
    }

    @Transactional(readOnly = true)
    public Page<NotificationResponseDto> getMyUnreadNotifications(
            int page,
            int size
    ) {

        UUID userId =
                getCurrentUserId();

        PageRequest pageable =
                PageRequest.of(
                        normalizePage(page),
                        normalizeSize(size),
                        Sort.by(
                                Sort.Direction.DESC,
                                "createdAt"
                        )
                );

        return notificationRepository
                .findByUserIdAndReadFalseOrderByCreatedAtDesc(
                        userId,
                        pageable
                )
                .map(
                        NotificationResponseDto::from
                );
    }

    @Transactional(readOnly = true)
    public long getUnreadCount() {

        UUID userId =
                getCurrentUserId();

        return notificationRepository
                .countByUserIdAndReadFalse(
                        userId
                );
    }

    @Transactional
    public void markAsRead(
            UUID notificationId
    ) {

        UUID userId =
                getCurrentUserId();

        NotificationEntity notification =
                notificationRepository
                        .findById(
                                notificationId
                        )
                        .orElseThrow(() ->
                                new ResponseStatusException(
                                        HttpStatus.NOT_FOUND,
                                        "Notification not found"
                                )
                        );

        if (!notification.getUser()
                .getId()
                .equals(userId)) {

            throw new ResponseStatusException(
                    HttpStatus.FORBIDDEN,
                    "You can only modify your own notifications"
            );
        }

        if (notification.isRead()) {
            return;
        }

        notification.setRead(true);
        notification.setReadAt(
                Instant.now()
        );

        notificationRepository.save(
                notification
        );
    }

    @Transactional
    public void markAllAsRead() {

        UUID userId =
                getCurrentUserId();

        notificationRepository.markAllAsRead(
                userId
        );
    }

    private UUID getCurrentUserId() {

        return SecurityUtils
                .getCurrentUserId()
                .orElseThrow(() ->
                        new ResponseStatusException(
                                HttpStatus.UNAUTHORIZED,
                                "Authentication required"
                        )
                );
    }

    private String normalizeReferenceType(
            String referenceType
    ) {

        if (referenceType == null ||
                referenceType.isBlank()) {

            return null;
        }

        return referenceType.trim()
                .toUpperCase();
    }

    private int normalizePage(
            int page
    ) {

        return Math.max(
                page,
                0
        );
    }

    private int normalizeSize(
            int size
    ) {

        if (size < 1) {
            return 20;
        }

        return Math.min(
                size,
                100
        );
    }
}