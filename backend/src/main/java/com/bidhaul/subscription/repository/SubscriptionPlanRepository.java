package com.bidhaul.subscription.repository;

import com.bidhaul.subscription.entity.SubscriptionPlanEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface SubscriptionPlanRepository
        extends JpaRepository<SubscriptionPlanEntity, UUID> {

    List<SubscriptionPlanEntity>
    findByActiveTrueOrderByMonthlyPriceAsc();

    Optional<SubscriptionPlanEntity>
    findByNameIgnoreCase(String name);

    boolean existsByNameIgnoreCase(String name);
}