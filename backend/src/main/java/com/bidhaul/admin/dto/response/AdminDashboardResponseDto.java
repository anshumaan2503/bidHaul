package com.bidhaul.admin.dto.response;

public record AdminDashboardResponseDto(

        long totalUsers,

        long activeCompanies,

        long activeTransporters,

        long liveTenders,

        long openNegotiations

) {
}