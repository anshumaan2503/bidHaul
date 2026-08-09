package com.bidhaul.security.jwt;

import com.bidhaul.common.enums.UserType;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;

class JwtTokenProviderTest {

    private JwtTokenProvider jwtTokenProvider;
    private final String secret = "8Zz5twkESgB8B2j6V1u0h7K3w8x9y0z1A2B3C4D5E6F7G8H9I0J1K2L3M4N5O6P7";
    private final long jwtExpirationMs = 3600000; // 1 hour
    private final long refreshExpirationMs = 86400000; // 1 day

    @BeforeEach
    void setUp() {
        jwtTokenProvider = new JwtTokenProvider(secret, jwtExpirationMs, refreshExpirationMs);
    }

    @Test
    void testGenerateAndValidateAccessToken() {
        UUID userId = UUID.randomUUID();
        String email = "test@bidhaul.com";
        UserType userType = UserType.COMPANY;

        String token = jwtTokenProvider.generateAccessToken(userId, email, userType);

        assertThat(token).isNotBlank();
        assertThat(jwtTokenProvider.validateToken(token)).isTrue();
        assertThat(jwtTokenProvider.getUserIdFromToken(token)).isEqualTo(userId);
        assertThat(jwtTokenProvider.getEmailFromToken(token)).isEqualTo(email);
        assertThat(jwtTokenProvider.getUserTypeFromToken(token)).isEqualTo(userType);
    }

    @Test
    void testGenerateAndValidateRefreshToken() {
        UUID userId = UUID.randomUUID();

        String refreshToken = jwtTokenProvider.generateRefreshToken(userId);

        assertThat(refreshToken).isNotBlank();
        assertThat(jwtTokenProvider.validateToken(refreshToken)).isTrue();
        assertThat(jwtTokenProvider.getUserIdFromToken(refreshToken)).isEqualTo(userId);
    }

    @Test
    void testInvalidJwtToken() {
        String malformedToken = "invalid.token.structure";
        assertThat(jwtTokenProvider.validateToken(malformedToken)).isFalse();
    }

    @Test
    void testExpiredJwtToken() {
        // Expired provider with -1000ms expiration
        JwtTokenProvider expiredProvider = new JwtTokenProvider(secret, -1000, -1000);
        String expiredToken = expiredProvider.generateAccessToken(UUID.randomUUID(), "expired@bidhaul.com", UserType.TRANSPORTER);

        assertThat(expiredProvider.validateToken(expiredToken)).isFalse();
    }
}
