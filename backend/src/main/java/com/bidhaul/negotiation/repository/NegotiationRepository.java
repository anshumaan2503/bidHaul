package com.bidhaul.negotiation.repository;

import com.bidhaul.negotiation.entity.Negotiation;
import com.bidhaul.negotiation.enums.NegotiationStatus;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface NegotiationRepository
        extends JpaRepository<Negotiation, UUID> {

    Optional<Negotiation> findByBidId(
            UUID bidId
    );

    boolean existsByBidId(
            UUID bidId
    );

    List<Negotiation>
    findByTenderIdOrderByCreatedAtAsc(
            UUID tenderId
    );

    List<Negotiation>
    findByCompanyIdOrderByCreatedAtDesc(
            UUID companyId
    );

    List<Negotiation>
    findByTransporterIdOrderByCreatedAtDesc(
            UUID transporterId
    );

    List<Negotiation>
    findByTenderIdAndStatus(
            UUID tenderId,
            NegotiationStatus status
    );

    long countByStatus(
            NegotiationStatus status
    );
}