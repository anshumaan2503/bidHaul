package com.bidhaul.delivery.repository;

import com.bidhaul.delivery.entity.DeliveryEntity;
import com.bidhaul.delivery.enums.DeliveryStatus;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface DeliveryRepository
        extends JpaRepository<DeliveryEntity, UUID> {

    Optional<DeliveryEntity> findByContractId(UUID contractId);

    List<DeliveryEntity> findByCompanyIdOrderByCreatedAtDesc(
            UUID companyId
    );

    List<DeliveryEntity> findByTransporterIdOrderByCreatedAtDesc(
            UUID transporterId
    );

    List<DeliveryEntity> findByStatusOrderByCreatedAtDesc(
            DeliveryStatus status
    );

    boolean existsByContractId(UUID contractId);
}