package com.bidhaul.admin.service;

import com.bidhaul.admin.dto.response.AdminDashboardResponseDto;
import com.bidhaul.audit.annotation.AuditLog;
import com.bidhaul.common.enums.UserStatus;
import com.bidhaul.common.enums.UserType;
import com.bidhaul.common.exception.ResourceNotFoundException;
import com.bidhaul.negotiation.enums.NegotiationStatus;
import com.bidhaul.negotiation.repository.NegotiationRepository;
import com.bidhaul.tender.enums.TenderStatus;
import com.bidhaul.tender.repository.TenderRepository;
import com.bidhaul.user.entity.UserEntity;
import com.bidhaul.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.UUID;

@Service
@RequiredArgsConstructor
public class AdminGovernanceService {

    private final UserRepository userRepository;

    private final TenderRepository tenderRepository;

    private final NegotiationRepository negotiationRepository;

    @Transactional(readOnly = true)
    public AdminDashboardResponseDto getDashboard() {

        return new AdminDashboardResponseDto(
                userRepository.count(),

                userRepository.countByUserTypeAndStatus(
                        UserType.COMPANY,
                        UserStatus.ACTIVE
                ),

                userRepository.countByUserTypeAndStatus(
                        UserType.TRANSPORTER,
                        UserStatus.ACTIVE
                ),

                tenderRepository.countByStatus(
                        TenderStatus.LIVE
                ),

                negotiationRepository.countByStatus(
                        NegotiationStatus.OPEN
                )
        );
    }

    @Transactional
    @AuditLog(
            action = "USER_SUSPENDED",
            entityType = "USER"
    )
    public void suspendUser(
            UUID userId,
            UUID actorUserId
    ) {

        if (userId.equals(actorUserId)) {

            throw new IllegalArgumentException(
                    "An administrator cannot suspend their own account"
            );
        }

        UserEntity user =
                userRepository
                        .findById(userId)
                        .orElseThrow(() ->
                                new ResourceNotFoundException(
                                        "User not found: "
                                                + userId
                                )
                        );

        if (user.getStatus() ==
                UserStatus.SUSPENDED) {

            return;
        }

        user.setStatus(
                UserStatus.SUSPENDED
        );

        userRepository.save(user);
    }

    @Transactional
    @AuditLog(
            action = "USER_ACTIVATED",
            entityType = "USER"
    )
    public void activateUser(
            UUID userId,
            UUID actorUserId
    ) {

        if (userId.equals(actorUserId)) {

            throw new IllegalArgumentException(
                    "An administrator cannot change their own account status"
            );
        }

        UserEntity user =
                userRepository
                        .findById(userId)
                        .orElseThrow(() ->
                                new ResourceNotFoundException(
                                        "User not found: "
                                                + userId
                                )
                        );

        if (user.getStatus() ==
                UserStatus.ACTIVE) {

            return;
        }

        user.setStatus(
                UserStatus.ACTIVE
        );

        userRepository.save(user);
    }
}