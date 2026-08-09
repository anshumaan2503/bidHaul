package com.bidhaul.contract.repository;

import com.bidhaul.contract.entity.ContractEntity;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;
import java.util.UUID;

public interface ContractRepository
        extends JpaRepository<ContractEntity, UUID> {

    Optional<ContractEntity> findByTenderId(UUID tenderId);

    Optional<ContractEntity> findByNegotiationId(UUID negotiationId);

    Optional<ContractEntity> findByContractNumber(String contractNumber);

    boolean existsByTenderId(UUID tenderId);
}