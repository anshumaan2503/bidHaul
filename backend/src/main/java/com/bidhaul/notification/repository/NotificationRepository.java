package com.bidhaul.notification.repository;

import com.bidhaul.notification.entity.NotificationEntity;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import org.springframework.data.repository.query.Param;

import java.util.UUID;

@Repository
public interface NotificationRepository
        extends JpaRepository<NotificationEntity, UUID> {

    Page<NotificationEntity>
    findByUserIdOrderByCreatedAtDesc(
            UUID userId,
            Pageable pageable
    );

    Page<NotificationEntity>
    findByUserIdAndReadFalseOrderByCreatedAtDesc(
            UUID userId,
            Pageable pageable
    );

    long countByUserIdAndReadFalse(
            UUID userId
    );

    @Modifying
    @Query("""
            UPDATE NotificationEntity n
            SET n.read = true,
                n.readAt = CURRENT_TIMESTAMP
            WHERE n.id = :notificationId
              AND n.user.id = :userId
              AND n.read = false
            """)
    int markAsRead(
            @Param("notificationId") UUID notificationId,
            @Param("userId") UUID userId
    );

    @Modifying
    @Query("""
            UPDATE NotificationEntity n
            SET n.read = true,
                n.readAt = CURRENT_TIMESTAMP
            WHERE n.user.id = :userId
              AND n.read = false
            """)
    int markAllAsRead(
            @Param("userId") UUID userId
    );
}