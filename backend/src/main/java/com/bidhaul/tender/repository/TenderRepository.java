package com.bidhaul.tender.repository;

import com.bidhaul.tender.entity.TenderEntity;
import com.bidhaul.tender.enums.TenderStatus;
import jakarta.persistence.LockModeType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Lock;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface TenderRepository
        extends JpaRepository<TenderEntity, UUID> {

    List<TenderEntity> findByCompanyIdOrderByCreatedAtDesc(
            UUID companyId
    );

    List<TenderEntity> findByStatusOrderByCreatedAtDesc(
            TenderStatus status
    );

    long countByStatus(
            TenderStatus status
    );

    @Lock(LockModeType.PESSIMISTIC_WRITE)
    @Query("""
            SELECT t
            FROM TenderEntity t
            WHERE t.id = :id
            """)
    Optional<TenderEntity> findByIdForUpdate(
            @Param("id") UUID id
    );
}