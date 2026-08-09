package com.bidhaul.negotiation.repository;

import com.bidhaul.negotiation.entity.NegotiationOffer;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface NegotiationOfferRepository
        extends JpaRepository<NegotiationOffer, UUID> {

    List<NegotiationOffer> findByNegotiationIdOrderByCreatedAtAsc(
            UUID negotiationId
    );

    Optional<NegotiationOffer>
    findTopByNegotiationIdOrderByCreatedAtDesc(
            UUID negotiationId
    );
}