package com.bidhaul.company.repository;

import com.bidhaul.common.enums.KycStatus;
import com.bidhaul.company.entity.CompanyProfileEntity;
import com.bidhaul.user.entity.UserEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface CompanyProfileRepository extends JpaRepository<CompanyProfileEntity, UUID> {

    Optional<CompanyProfileEntity> findByUser(UserEntity user);

    Optional<CompanyProfileEntity> findByUserId(UUID userId);

    boolean existsByUserId(UUID userId);

    boolean existsByGstNumber(String gstNumber);

    boolean existsByLicenseNumber(String licenseNumber);

    List<CompanyProfileEntity> findByVerificationStatusOrderBySubmittedAtAsc(KycStatus verificationStatus);
}