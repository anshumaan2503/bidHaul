package com.bidhaul.auth.service;

import com.bidhaul.auth.dto.request.AdminLoginRequestDto;
import com.bidhaul.auth.dto.request.LoginRequestDto;
import com.bidhaul.auth.dto.request.RefreshTokenRequestDto;
import com.bidhaul.auth.dto.request.SignupRequestDto;
import com.bidhaul.auth.dto.response.AuthResponseDto;
import com.bidhaul.auth.dto.response.UserResponseDto;
import com.bidhaul.auth.entity.RefreshTokenEntity;
import com.bidhaul.auth.repository.RefreshTokenRepository;
import com.bidhaul.common.enums.UserStatus;
import com.bidhaul.common.enums.UserType;
import com.bidhaul.common.exception.AccountSuspendedException;
import com.bidhaul.common.exception.InvalidCredentialsException;
import com.bidhaul.common.exception.InvalidTokenException;
import com.bidhaul.common.exception.ResourceNotFoundException;
import com.bidhaul.common.exception.UserAlreadyExistsException;
import com.bidhaul.security.jwt.JwtTokenProvider;
import com.bidhaul.user.entity.UserEntity;
import com.bidhaul.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.time.Instant;
import java.util.HexFormat;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final UserRepository userRepository;
    private final RefreshTokenRepository refreshTokenRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtTokenProvider tokenProvider;

    @Transactional
    public AuthResponseDto register(SignupRequestDto request) {
        if (request.getRole() == UserType.ADMIN || request.getRole() == UserType.SUPER_ADMIN) {
            throw new IllegalArgumentException("Public registration of administrative roles is forbidden");
        }

        String email = request.getEmail().toLowerCase().trim();
        if (userRepository.existsByEmail(email)) {
            throw new UserAlreadyExistsException("An account with email address '" + email + "' already exists");
        }

        UserEntity user = UserEntity.builder()
                .email(email)
                .passwordHash(passwordEncoder.encode(request.getPassword()))
                .fullName(request.getFullName())
                .phone(request.getPhone())
                .userType(request.getRole())
                .status(UserStatus.ACTIVE)
                .build();

        UserEntity savedUser = userRepository.save(user);

        return createAuthResponse(savedUser);
    }

    @Transactional
    public AuthResponseDto login(LoginRequestDto request) {
        String email = request.getEmail().toLowerCase().trim();
        UserEntity user = userRepository.findByEmail(email)
                .orElseThrow(() -> new InvalidCredentialsException("Invalid email or password"));

        if (!passwordEncoder.matches(request.getPassword(), user.getPasswordHash())) {
            throw new InvalidCredentialsException("Invalid email or password");
        }

        if (user.getStatus() == UserStatus.SUSPENDED) {
            throw new AccountSuspendedException("Account is suspended. Please contact platform support.");
        }

        if (request.getRole() != null && user.getUserType() != request.getRole()) {
            throw new InvalidCredentialsException("Account role does not match the requested portal");
        }

        return createAuthResponse(user);
    }

    @Transactional
    public AuthResponseDto adminLogin(AdminLoginRequestDto request) {
        String email = request.getEmail().toLowerCase().trim();
        UserEntity user = userRepository.findByEmail(email)
                .orElseThrow(() -> new InvalidCredentialsException("Invalid admin credentials"));

        if (!passwordEncoder.matches(request.getPassword(), user.getPasswordHash())) {
            throw new InvalidCredentialsException("Invalid admin credentials");
        }

        if (user.getUserType() != UserType.ADMIN && user.getUserType() != UserType.SUPER_ADMIN) {
            throw new InvalidCredentialsException("Access denied: Administrative privileges required");
        }

        if (user.getStatus() == UserStatus.SUSPENDED) {
            throw new AccountSuspendedException("Account is suspended. Please contact platform support.");
        }

        return createAuthResponse(user);
    }

    @Transactional
    public AuthResponseDto refreshToken(RefreshTokenRequestDto request) {
        String rawRefreshToken = request.getRefreshToken();
        if (!tokenProvider.validateToken(rawRefreshToken)) {
            throw new InvalidTokenException("Invalid or expired refresh token");
        }

        String tokenHash = hashToken(rawRefreshToken);

        // Atomic revocation at database level to eliminate race conditions
        int updatedRows = refreshTokenRepository.revokeByTokenHash(tokenHash);
        if (updatedRows == 0) {
            throw new InvalidTokenException("Refresh token is invalid, expired, or already consumed");
        }

        RefreshTokenEntity refreshTokenEntity = refreshTokenRepository.findByTokenHash(tokenHash)
                .orElseThrow(() -> new InvalidTokenException("Refresh token not found"));

        if (refreshTokenEntity.getExpiresAt().isBefore(Instant.now())) {
            throw new InvalidTokenException("Refresh token is expired");
        }

        UserEntity user = refreshTokenEntity.getUser();
        if (user.getStatus() == UserStatus.SUSPENDED) {
            throw new AccountSuspendedException("Account is suspended. Please contact platform support.");
        }

        return createAuthResponse(user);
    }

    @Transactional(readOnly = true)
    public UserResponseDto getCurrentUserResponse(UUID userId) {
        UserEntity user = userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("User identity not found"));
        return mapToUserResponseDto(user);
    }

    private AuthResponseDto createAuthResponse(UserEntity user) {
        String accessToken = tokenProvider.generateAccessToken(user.getId(), user.getEmail(), user.getUserType());
        String refreshToken = tokenProvider.generateRefreshToken(user.getId());

        // Save hashed refresh token
        RefreshTokenEntity refreshTokenEntity = RefreshTokenEntity.builder()
                .user(user)
                .tokenHash(hashToken(refreshToken))
                .expiresAt(Instant.now().plusMillis(tokenProvider.getRefreshExpirationMs()))
                .revoked(false)
                .build();
        refreshTokenRepository.save(refreshTokenEntity);

        return AuthResponseDto.builder()
                .token(accessToken)
                .refreshToken(refreshToken)
                .tokenType("Bearer")
                .expiresIn(tokenProvider.getJwtExpirationMs() / 1000)
                .user(mapToUserResponseDto(user))
                .build();
    }

    private UserResponseDto mapToUserResponseDto(UserEntity user) {
        return UserResponseDto.builder()
                .id(user.getId())
                .email(user.getEmail())
                .fullName(user.getFullName())
                .phone(user.getPhone())
                .userType(user.getUserType())
                .status(user.getStatus())
                .createdAt(user.getCreatedAt())
                .build();
    }

    private String hashToken(String token) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(token.getBytes(StandardCharsets.UTF_8));
            return HexFormat.of().formatHex(hash);
        } catch (NoSuchAlgorithmException e) {
            throw new IllegalStateException("SHA-256 algorithm unavailable", e);
        }
    }
}
