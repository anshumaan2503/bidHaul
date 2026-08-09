package com.bidhaul.notification.controller;

import com.bidhaul.notification.dto.response.NotificationResponseDto;
import com.bidhaul.notification.service.NotificationService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@RestController
@RequestMapping("/api/v1/notifications")
@RequiredArgsConstructor
public class NotificationController {

    private final NotificationService notificationService;

    @GetMapping("/my")
    @PreAuthorize("hasAnyRole('COMPANY', 'TRANSPORTER', 'ADMIN', 'SUPER_ADMIN')")
    public ResponseEntity<Page<NotificationResponseDto>>
    getMyNotifications(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size
    ) {

        return ResponseEntity.ok(
                notificationService.getMyNotifications(
                        page,
                        size
                )
        );
    }

    @GetMapping("/my/unread")
    @PreAuthorize("hasAnyRole('COMPANY', 'TRANSPORTER', 'ADMIN', 'SUPER_ADMIN')")
    public ResponseEntity<Page<NotificationResponseDto>>
    getMyUnreadNotifications(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size
    ) {

        return ResponseEntity.ok(
                notificationService.getMyUnreadNotifications(
                        page,
                        size
                )
        );
    }

    @GetMapping("/my/unread/count")
    @PreAuthorize("hasAnyRole('COMPANY', 'TRANSPORTER', 'ADMIN', 'SUPER_ADMIN')")
    public ResponseEntity<Long> getUnreadCount() {

        return ResponseEntity.ok(
                notificationService.getUnreadCount()
        );
    }

    @PatchMapping("/{id}/read")
    @PreAuthorize("hasAnyRole('COMPANY', 'TRANSPORTER', 'ADMIN', 'SUPER_ADMIN')")
    public ResponseEntity<Void> markAsRead(
            @PathVariable UUID id
    ) {

        notificationService.markAsRead(
                id
        );

        return ResponseEntity.noContent()
                .build();
    }

    @PatchMapping("/my/read-all")
    @PreAuthorize("hasAnyRole('COMPANY', 'TRANSPORTER', 'ADMIN', 'SUPER_ADMIN')")
    public ResponseEntity<Void> markAllAsRead() {

        notificationService.markAllAsRead();

        return ResponseEntity.noContent()
                .build();
    }
}