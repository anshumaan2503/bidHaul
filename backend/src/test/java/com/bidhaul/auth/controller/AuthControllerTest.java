package com.bidhaul.auth.controller;

import com.bidhaul.auth.dto.request.AdminLoginRequestDto;
import com.bidhaul.auth.dto.request.LoginRequestDto;
import com.bidhaul.auth.dto.request.RefreshTokenRequestDto;
import com.bidhaul.auth.dto.request.SignupRequestDto;
import com.bidhaul.common.enums.UserStatus;
import com.bidhaul.common.enums.UserType;
import com.bidhaul.user.entity.UserEntity;
import com.bidhaul.user.repository.UserRepository;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.test.web.servlet.setup.SecurityMockMvcConfigurers;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.context.WebApplicationContext;

import java.util.Map;
import java.util.UUID;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@Transactional
class AuthControllerTest {

    private MockMvc mockMvc;

    @Autowired
    private WebApplicationContext context;

    @Autowired
    private ObjectMapper objectMapper;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @BeforeEach
    void setUp() {
        mockMvc = MockMvcBuilders
                .webAppContextSetup(context)
                .apply(SecurityMockMvcConfigurers.springSecurity())
                .build();
    }

    @Test
    void testSignupSuccess() throws Exception {
        String email = "api_shipper_" + UUID.randomUUID() + "@bidhaul.com";
        SignupRequestDto signup = SignupRequestDto.builder()
                .email(email)
                .password("Password123!")
                .fullName("API Shipper")
                .companyName("API Shipper Co")
                .role(UserType.COMPANY)
                .build();

        mockMvc.perform(post("/api/v1/auth/signup")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(signup)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.token").exists())
                .andExpect(jsonPath("$.refreshToken").exists())
                .andExpect(jsonPath("$.tokenType").value("Bearer"))
                .andExpect(jsonPath("$.user.email").value(email))
                .andExpect(jsonPath("$.user.userType").value("COMPANY"))
                .andExpect(jsonPath("$.user.passwordHash").doesNotExist());
    }

    @Test
    void testSignupValidationErrorForInvalidEmailAndPassword() throws Exception {
        SignupRequestDto signup = SignupRequestDto.builder()
                .email("invalid-email")
                .password("short")
                .fullName("")
                .build();

        mockMvc.perform(post("/api/v1/auth/signup")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(signup)))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.validationErrors.email").exists())
                .andExpect(jsonPath("$.validationErrors.password").exists());
    }

    @Test
    void testLoginSuccess() throws Exception {
        String email = "api_carrier_" + UUID.randomUUID() + "@bidhaul.com";
        UserEntity user = UserEntity.builder()
                .email(email)
                .passwordHash(passwordEncoder.encode("Secret123!"))
                .fullName("API Carrier")
                .userType(UserType.TRANSPORTER)
                .status(UserStatus.ACTIVE)
                .build();
        userRepository.save(user);

        LoginRequestDto login = LoginRequestDto.builder()
                .email(email)
                .password("Secret123!")
                .role(UserType.TRANSPORTER)
                .build();

        mockMvc.perform(post("/api/v1/auth/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(login)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.token").exists())
                .andExpect(jsonPath("$.user.email").value(email));
    }

    @Test
    void testLoginInvalidPasswordReturnsUnauthorized() throws Exception {
        String email = "api_carrier_" + UUID.randomUUID() + "@bidhaul.com";
        UserEntity user = UserEntity.builder()
                .email(email)
                .passwordHash(passwordEncoder.encode("Secret123!"))
                .fullName("API Carrier")
                .userType(UserType.TRANSPORTER)
                .status(UserStatus.ACTIVE)
                .build();
        userRepository.save(user);

        LoginRequestDto login = LoginRequestDto.builder()
                .email(email)
                .password("WrongPassword")
                .build();

        mockMvc.perform(post("/api/v1/auth/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(login)))
                .andExpect(status().isUnauthorized())
                .andExpect(jsonPath("$.message").value("Invalid email or password"));
    }

    @Test
    void testAdminLoginSuccess() throws Exception {
        String email = "admin_api_" + UUID.randomUUID() + "@bidhaul.com";
        UserEntity admin = UserEntity.builder()
                .email(email)
                .passwordHash(passwordEncoder.encode("AdminPass123!"))
                .fullName("Admin API User")
                .userType(UserType.ADMIN)
                .status(UserStatus.ACTIVE)
                .build();
        userRepository.save(admin);

        AdminLoginRequestDto adminLogin = AdminLoginRequestDto.builder()
                .email(email)
                .password("AdminPass123!")
                .build();

        mockMvc.perform(post("/api/v1/auth/admin-login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(adminLogin)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.token").exists())
                .andExpect(jsonPath("$.user.userType").value("ADMIN"));
    }

    @Test
    void testProtectedEndpointMeReturnsUnauthorizedWithoutToken() throws Exception {
        mockMvc.perform(get("/api/v1/auth/me"))
                .andExpect(status().isUnauthorized())
                .andExpect(jsonPath("$.message").value("Full authentication is required to access this resource"));
    }

    @Test
    void testProtectedEndpointMeReturnsUserWithValidToken() throws Exception {
        String email = "authed_" + UUID.randomUUID() + "@bidhaul.com";
        SignupRequestDto signup = SignupRequestDto.builder()
                .email(email)
                .password("Password123!")
                .fullName("Authed User")
                .role(UserType.COMPANY)
                .build();

        MvcResult signupResult = mockMvc.perform(post("/api/v1/auth/signup")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(signup)))
                .andExpect(status().isCreated())
                .andReturn();

        String jsonResponse = signupResult.getResponse().getContentAsString();
        Map<?, ?> map = objectMapper.readValue(jsonResponse, Map.class);
        String token = (String) map.get("token");

        mockMvc.perform(get("/api/v1/auth/me")
                        .header("Authorization", "Bearer " + token))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.email").value(email))
                .andExpect(jsonPath("$.userType").value("COMPANY"));
    }

    @Test
    void testRefreshTokenEndpoint() throws Exception {
        String email = "refresh_api_" + UUID.randomUUID() + "@bidhaul.com";
        SignupRequestDto signup = SignupRequestDto.builder()
                .email(email)
                .password("Password123!")
                .fullName("Refresh API User")
                .role(UserType.TRANSPORTER)
                .build();

        MvcResult signupResult = mockMvc.perform(post("/api/v1/auth/signup")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(signup)))
                .andExpect(status().isCreated())
                .andReturn();

        String jsonResponse = signupResult.getResponse().getContentAsString();
        Map<?, ?> map = objectMapper.readValue(jsonResponse, Map.class);
        String refreshToken = (String) map.get("refreshToken");

        RefreshTokenRequestDto refreshRequest = RefreshTokenRequestDto.builder()
                .refreshToken(refreshToken)
                .build();

        mockMvc.perform(post("/api/v1/auth/refresh")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(refreshRequest)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.token").exists())
                .andExpect(jsonPath("$.refreshToken").exists());
    }
}
