package com.bidhaul.subscription.repository;

import com.bidhaul.subscription.entity.UserSubscriptionEntity;
import com.bidhaul.subscription.enums.SubscriptionStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface UserSubscriptionRepository
        extends JpaRepository<UserSubscriptionEntity, UUID> {

    Optional<UserSubscriptionEntity>
    findTopByUserIdOrderByCreatedAtDesc(UUID userId);

    Optional<UserSubscriptionEntity>
    findFirstByUserIdAndStatusOrderByCreatedAtDesc(
            UUID userId,
            SubscriptionStatus status
    );

    List<UserSubscriptionEntity>
    findByUserIdOrderByCreatedAtDesc(UUID userId);

    boolean existsByUserIdAndStatus(
            UUID userId,
            SubscriptionStatus status
    );
}