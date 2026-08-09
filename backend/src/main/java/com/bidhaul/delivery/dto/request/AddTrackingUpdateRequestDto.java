package com.bidhaul.delivery.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AddTrackingUpdateRequestDto {

    @NotBlank(message = "Location is required")
    private String location;

    private String remarks;
}