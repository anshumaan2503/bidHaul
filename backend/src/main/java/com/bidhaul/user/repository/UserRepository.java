package com.bidhaul.user.repository;

import com.bidhaul.common.enums.UserStatus;
import com.bidhaul.common.enums.UserType;
import com.bidhaul.user.entity.UserEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

@Repository
public interface UserRepository
        extends JpaRepository<UserEntity, UUID> {

    Optional<UserEntity> findByEmail(
            String email
    );

    boolean existsByEmail(
            String email
    );

    long countByUserTypeAndStatus(
            UserType userType,
            UserStatus status
    );
}