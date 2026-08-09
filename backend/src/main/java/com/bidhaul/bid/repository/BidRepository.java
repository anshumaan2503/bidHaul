package com.bidhaul.bid.repository;

import com.bidhaul.bid.entity.BidEntity;
import com.bidhaul.bid.enums.BidStatus;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface BidRepository extends JpaRepository<BidEntity, UUID> {

    List<BidEntity> findByTenderIdOrderByAmountAscCreatedAtAsc(
            UUID tenderId
    );

    List<BidEntity> findByTenderIdAndStatusOrderByAmountAscCreatedAtAsc(
            UUID tenderId,
            BidStatus status
    );

    List<BidEntity> findByTransporterIdOrderByCreatedAtDesc(
            UUID transporterId
    );

    Optional<BidEntity> findTopByTenderIdAndStatusOrderByAmountAscCreatedAtAsc(
            UUID tenderId,
            BidStatus status
    );
}