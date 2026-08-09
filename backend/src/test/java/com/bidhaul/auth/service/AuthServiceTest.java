package com.bidhaul.auth.service;

import com.bidhaul.auth.dto.request.AdminLoginRequestDto;
import com.bidhaul.auth.dto.request.LoginRequestDto;
import com.bidhaul.auth.dto.request.RefreshTokenRequestDto;
import com.bidhaul.auth.dto.request.SignupRequestDto;
import com.bidhaul.auth.dto.response.AuthResponseDto;
import com.bidhaul.auth.dto.response.UserResponseDto;
import com.bidhaul.common.enums.UserStatus;
import com.bidhaul.common.enums.UserType;
import com.bidhaul.common.exception.AccountSuspendedException;
import com.bidhaul.common.exception.InvalidCredentialsException;
import com.bidhaul.common.exception.InvalidTokenException;
import com.bidhaul.common.exception.UserAlreadyExistsException;
import com.bidhaul.user.entity.UserEntity;
import com.bidhaul.user.repository.UserRepository;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.transaction.annotation.Transactional;

import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

@SpringBootTest
@Transactional
class AuthServiceTest {

    @Autowired
    private AuthService authService;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Test
    void testValidRegistration() {
        String uniqueEmail = "shipper_" + UUID.randomUUID() + "@bidhaul.com";
        SignupRequestDto request = SignupRequestDto.builder()
                .email(uniqueEmail)
                .password("Password123!")
                .fullName("Apex Shipper")
                .companyName("Apex Logistics")
                .phone("+15550001111")
                .role(UserType.COMPANY)
                .build();

        AuthResponseDto response = authService.register(request);

        assertThat(response).isNotNull();
        assertThat(response.getToken()).isNotBlank();
        assertThat(response.getRefreshToken()).isNotBlank();
        assertThat(response.getUser()).isNotNull();
        assertThat(response.getUser().getEmail()).isEqualTo(uniqueEmail);
        assertThat(response.getUser().getUserType()).isEqualTo(UserType.COMPANY);

        // Verify password hash in database
        UserEntity entity = userRepository.findByEmail(uniqueEmail).orElseThrow();
        assertThat(entity.getPasswordHash()).isNotEqualTo("Password123!");
        assertThat(passwordEncoder.matches("Password123!", entity.getPasswordHash())).isTrue();
    }

    @Test
    void testDuplicateEmailRegistrationThrowsException() {
        String uniqueEmail = "duplicate_" + UUID.randomUUID() + "@bidhaul.com";
        SignupRequestDto request = SignupRequestDto.builder()
                .email(uniqueEmail)
                .password("Password123!")
                .fullName("Test User")
                .role(UserType.TRANSPORTER)
                .build();

        authService.register(request);

        assertThatThrownBy(() -> authService.register(request))
                .isInstanceOf(UserAlreadyExistsException.class)
                .hasMessageContaining("already exists");
    }

    @Test
    void testAdminPublicRegistrationForbidden() {
        SignupRequestDto request = SignupRequestDto.builder()
                .email("admin_try@bidhaul.com")
                .password("Password123!")
                .fullName("Fake Admin")
                .role(UserType.ADMIN)
                .build();

        assertThatThrownBy(() -> authService.register(request))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("Public registration of administrative roles is forbidden");
    }

    @Test
    void testLoginWithValidCredentials() {
        String email = "carrier_" + UUID.randomUUID() + "@bidhaul.com";
        SignupRequestDto signupRequest = SignupRequestDto.builder()
                .email(email)
                .password("Secret123!")
                .fullName("Carrier Owner")
                .role(UserType.TRANSPORTER)
                .build();
        authService.register(signupRequest);

        LoginRequestDto loginRequest = LoginRequestDto.builder()
                .email(email)
                .password("Secret123!")
                .role(UserType.TRANSPORTER)
                .build();

        AuthResponseDto response = authService.login(loginRequest);

        assertThat(response).isNotNull();
        assertThat(response.getToken()).isNotBlank();
        assertThat(response.getUser().getEmail()).isEqualTo(email);
    }

    @Test
    void testLoginWithInvalidPasswordThrowsException() {
        String email = "carrier_" + UUID.randomUUID() + "@bidhaul.com";
        SignupRequestDto signupRequest = SignupRequestDto.builder()
                .email(email)
                .password("Secret123!")
                .fullName("Carrier Owner")
                .role(UserType.TRANSPORTER)
                .build();
        authService.register(signupRequest);

        LoginRequestDto loginRequest = LoginRequestDto.builder()
                .email(email)
                .password("WrongPassword")
                .build();

        assertThatThrownBy(() -> authService.login(loginRequest))
                .isInstanceOf(InvalidCredentialsException.class)
                .hasMessageContaining("Invalid email or password");
    }

    @Test
    void testLoginNonExistentUserThrowsException() {
        LoginRequestDto loginRequest = LoginRequestDto.builder()
                .email("nonexistent@bidhaul.com")
                .password("Secret123!")
                .build();

        assertThatThrownBy(() -> authService.login(loginRequest))
                .isInstanceOf(InvalidCredentialsException.class)
                .hasMessageContaining("Invalid email or password");
    }

    @Test
    void testLoginSuspendedUserThrowsException() {
        String email = "suspended_" + UUID.randomUUID() + "@bidhaul.com";
        UserEntity entity = UserEntity.builder()
                .email(email)
                .passwordHash(passwordEncoder.encode("Secret123!"))
                .fullName("Suspended User")
                .userType(UserType.COMPANY)
                .status(UserStatus.SUSPENDED)
                .build();
        userRepository.save(entity);

        LoginRequestDto loginRequest = LoginRequestDto.builder()
                .email(email)
                .password("Secret123!")
                .build();

        assertThatThrownBy(() -> authService.login(loginRequest))
                .isInstanceOf(AccountSuspendedException.class)
                .hasMessageContaining("Account is suspended");
    }

    @Test
    void testAdminLoginSuccess() {
        String email = "admin_" + UUID.randomUUID() + "@bidhaul.com";
        UserEntity admin = UserEntity.builder()
                .email(email)
                .passwordHash(passwordEncoder.encode("AdminSecret123!"))
                .fullName("System Admin")
                .userType(UserType.ADMIN)
                .status(UserStatus.ACTIVE)
                .build();
        userRepository.save(admin);

        AdminLoginRequestDto request = AdminLoginRequestDto.builder()
                .email(email)
                .password("AdminSecret123!")
                .build();

        AuthResponseDto response = authService.adminLogin(request);
        assertThat(response.getToken()).isNotBlank();
        assertThat(response.getUser().getUserType()).isEqualTo(UserType.ADMIN);
    }

    @Test
    void testRefreshTokenRotation() {
        String email = "rotation_" + UUID.randomUUID() + "@bidhaul.com";
        SignupRequestDto signup = SignupRequestDto.builder()
                .email(email)
                .password("Password123!")
                .fullName("Rotation User")
                .role(UserType.COMPANY)
                .build();

        AuthResponseDto initialAuth = authService.register(signup);
        String firstRefreshToken = initialAuth.getRefreshToken();

        RefreshTokenRequestDto refreshRequest = RefreshTokenRequestDto.builder()
                .refreshToken(firstRefreshToken)
                .build();

        AuthResponseDto rotatedAuth = authService.refreshToken(refreshRequest);

        assertThat(rotatedAuth.getToken()).isNotBlank();
        assertThat(rotatedAuth.getRefreshToken()).isNotBlank();
        assertThat(rotatedAuth.getRefreshToken()).isNotEqualTo(firstRefreshToken);

        // Attempting to reuse revoked refresh token must fail
        assertThatThrownBy(() -> authService.refreshToken(refreshRequest))
                .isInstanceOf(InvalidTokenException.class);
    }

    @Test
    void testGetCurrentUserResponse() {
        String email = "me_" + UUID.randomUUID() + "@bidhaul.com";
        SignupRequestDto signup = SignupRequestDto.builder()
                .email(email)
                .password("Password123!")
                .fullName("Profile User")
                .role(UserType.TRANSPORTER)
                .build();

        AuthResponseDto auth = authService.register(signup);
        UserResponseDto userResponse = authService.getCurrentUserResponse(auth.getUser().getId());

        assertThat(userResponse).isNotNull();
        assertThat(userResponse.getEmail()).isEqualTo(email);
        assertThat(userResponse.getUserType()).isEqualTo(UserType.TRANSPORTER);
    }

    @Test
    void testConcurrentRefreshTokenRotation() throws Exception {
        String email = "concurrent_" + UUID.randomUUID() + "@bidhaul.com";
        SignupRequestDto signup = SignupRequestDto.builder()
                .email(email)
                .password("Password123!")
                .fullName("Concurrent User")
                .role(UserType.COMPANY)
                .build();

        AuthResponseDto initialAuth = authService.register(signup);
        String refreshTokenToReplay = initialAuth.getRefreshToken();

        // Commit setup data so background executor threads can access the token in PostgreSQL
        org.springframework.test.context.transaction.TestTransaction.flagForCommit();
        org.springframework.test.context.transaction.TestTransaction.end();

        RefreshTokenRequestDto refreshRequest = RefreshTokenRequestDto.builder()
                .refreshToken(refreshTokenToReplay)
                .build();

        int numThreads = 2;
        java.util.concurrent.ExecutorService executor = java.util.concurrent.Executors.newFixedThreadPool(numThreads);
        java.util.concurrent.CountDownLatch startLatch = new java.util.concurrent.CountDownLatch(1);

        java.util.List<java.util.concurrent.Future<AuthResponseDto>> futures = new java.util.ArrayList<>();
        java.util.List<Throwable> exceptions = new java.util.ArrayList<>();

        for (int i = 0; i < numThreads; i++) {
            futures.add(executor.submit(() -> {
                startLatch.await();
                return authService.refreshToken(refreshRequest);
            }));
        }

        startLatch.countDown();
        executor.shutdown();

        int successCount = 0;
        int failureCount = 0;

        for (java.util.concurrent.Future<AuthResponseDto> future : futures) {
            try {
                AuthResponseDto dto = future.get();
                if (dto != null && dto.getToken() != null) {
                    successCount++;
                }
            } catch (java.util.concurrent.ExecutionException e) {
                if (e.getCause() instanceof InvalidTokenException) {
                    failureCount++;
                } else {
                    exceptions.add(e.getCause());
                }
            }
        }

        assertThat(successCount).isEqualTo(1);
        assertThat(failureCount).isEqualTo(1);
        assertThat(exceptions).isEmpty();
    }
}
