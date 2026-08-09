package com.bidhaul.auth.controller;

import com.bidhaul.auth.dto.request.AdminLoginRequestDto;
import com.bidhaul.auth.dto.request.LoginRequestDto;
import com.bidhaul.auth.dto.request.RefreshTokenRequestDto;
import com.bidhaul.auth.dto.request.SignupRequestDto;
import com.bidhaul.auth.dto.response.AuthResponseDto;
import com.bidhaul.auth.dto.response.UserResponseDto;
import com.bidhaul.auth.service.AuthService;
import com.bidhaul.security.util.SecurityUtils;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.UUID;

@RestController
@RequestMapping("/api/v1/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;

    @PostMapping("/signup")
    public ResponseEntity<AuthResponseDto> register(@Valid @RequestBody SignupRequestDto request) {
        AuthResponseDto response = authService.register(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    @PostMapping("/login")
    public ResponseEntity<AuthResponseDto> login(@Valid @RequestBody LoginRequestDto request) {
        AuthResponseDto response = authService.login(request);
        return ResponseEntity.ok(response);
    }

    @PostMapping("/admin-login")
    public ResponseEntity<AuthResponseDto> adminLogin(@Valid @RequestBody AdminLoginRequestDto request) {
        AuthResponseDto response = authService.adminLogin(request);
        return ResponseEntity.ok(response);
    }

    @PostMapping("/refresh")
    public ResponseEntity<AuthResponseDto> refreshToken(@Valid @RequestBody RefreshTokenRequestDto request) {
        AuthResponseDto response = authService.refreshToken(request);
        return ResponseEntity.ok(response);
    }

    @GetMapping("/me")
    public ResponseEntity<UserResponseDto> getCurrentUser() {
        UUID currentUserId = SecurityUtils.getCurrentUserId()
                .orElseThrow(() -> new IllegalStateException("Authenticated user identity unavailable in SecurityContext"));
        UserResponseDto response = authService.getCurrentUserResponse(currentUserId);
        return ResponseEntity.ok(response);
    }
}
