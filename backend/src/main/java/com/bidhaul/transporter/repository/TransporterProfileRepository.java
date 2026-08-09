package com.bidhaul.transporter.repository;

import com.bidhaul.common.enums.KycStatus;
import com.bidhaul.transporter.entity.TransporterProfileEntity;
import com.bidhaul.user.entity.UserEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface TransporterProfileRepository extends JpaRepository<TransporterProfileEntity, UUID> {

    Optional<TransporterProfileEntity> findByUser(UserEntity user);

    Optional<TransporterProfileEntity> findByUserId(UUID userId);

    boolean existsByUserId(UUID userId);

    boolean existsByLicenseNumber(String licenseNumber);

    List<TransporterProfileEntity> findByVerificationStatusOrderBySubmittedAtAsc(KycStatus verificationStatus);
}