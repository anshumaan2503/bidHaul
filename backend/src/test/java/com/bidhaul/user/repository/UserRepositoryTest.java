package com.bidhaul.user.repository;

import com.bidhaul.common.enums.UserStatus;
import com.bidhaul.common.enums.UserType;
import com.bidhaul.user.entity.UserEntity;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.dao.DataIntegrityViolationException;

import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

@SpringBootTest
class UserRepositoryTest {

    @Autowired
    private UserRepository userRepository;

    @Test
    @DisplayName("Should persist and retrieve user by email with correct enums and timestamps")
    void testSaveAndFindByEmail() {
        String testEmail = "shipper_" + System.currentTimeMillis() + "@bidhaul.com";

        UserEntity user = UserEntity.builder()
                .email(testEmail)
                .passwordHash("$2a$12$e8Y5lqX4qB/1m2K3L4M5N6O7P8Q9R0S1T2U3V4W5X6Y7Z8")
                .fullName("Logistics Express Corp")
                .phone("+91 9876543210")
                .userType(UserType.COMPANY)
                .status(UserStatus.ACTIVE)
                .build();

        UserEntity savedUser = userRepository.save(user);

        assertThat(savedUser.getId()).isNotNull();
        assertThat(savedUser.getCreatedAt()).isNotNull();
        assertThat(savedUser.getUpdatedAt()).isNotNull();

        Optional<UserEntity> fetchedUserOpt = userRepository.findByEmail(testEmail);
        assertThat(fetchedUserOpt).isPresent();

        UserEntity fetchedUser = fetchedUserOpt.get();
        assertThat(fetchedUser.getEmail()).isEqualTo(testEmail);
        assertThat(fetchedUser.getFullName()).isEqualTo("Logistics Express Corp");
        assertThat(fetchedUser.getUserType()).isEqualTo(UserType.COMPANY);
        assertThat(fetchedUser.getStatus()).isEqualTo(UserStatus.ACTIVE);
    }

    @Test
    @DisplayName("Should enforce email uniqueness constraint at database level")
    void testDuplicateEmailConstraint() {
        String duplicateEmail = "duplicate_" + System.currentTimeMillis() + "@bidhaul.com";

        UserEntity user1 = UserEntity.builder()
                .email(duplicateEmail)
                .passwordHash("hash1")
                .fullName("Company One")
                .userType(UserType.COMPANY)
                .status(UserStatus.ACTIVE)
                .build();
        userRepository.saveAndFlush(user1);

        UserEntity user2 = UserEntity.builder()
                .email(duplicateEmail)
                .passwordHash("hash2")
                .fullName("Company Two")
                .userType(UserType.TRANSPORTER)
                .status(UserStatus.PENDING_VERIFICATION)
                .build();

        assertThatThrownBy(() -> userRepository.saveAndFlush(user2))
                .isInstanceOf(DataIntegrityViolationException.class);
    }
}
