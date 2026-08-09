package com.bidhaul.auth.dto.response;

import com.bidhaul.common.enums.UserStatus;
import com.bidhaul.common.enums.UserType;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;
import java.util.UUID;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserResponseDto {
    private UUID id;
    private String email;
    private String fullName;
    private String phone;
    private UserType userType;
    private UserStatus status;
    private Instant createdAt;
}
