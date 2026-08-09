package com.bidhaul.admin.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class KycRejectionRequestDto {

    @NotBlank(message = "Rejection reason is required")
    private String rejectionReason;
}