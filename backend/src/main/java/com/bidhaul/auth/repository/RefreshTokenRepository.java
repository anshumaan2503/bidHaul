package com.bidhaul.auth.repository;

import com.bidhaul.auth.entity.RefreshTokenEntity;
import com.bidhaul.user.entity.UserEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

@Repository
public interface RefreshTokenRepository extends JpaRepository<RefreshTokenEntity, UUID> {

    Optional<RefreshTokenEntity> findByTokenHash(String tokenHash);

    @Modifying
    @Query("UPDATE RefreshTokenEntity r SET r.revoked = true WHERE r.tokenHash = :tokenHash AND r.revoked = false")
    int revokeByTokenHash(@Param("tokenHash") String tokenHash);

    void deleteByUser(UserEntity user);
}
