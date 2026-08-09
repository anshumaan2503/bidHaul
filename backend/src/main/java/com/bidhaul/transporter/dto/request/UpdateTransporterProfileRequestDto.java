package com.bidhaul.transporter.dto.request;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UpdateTransporterProfileRequestDto {

    @NotBlank(message = "Company name is required")
    private String companyName;

    @NotBlank(message = "Vehicle type is required")
    private String vehicleType;

    @NotNull(message = "Fleet size is required")
    @Min(value = 0, message = "Fleet size must be greater than or equal to 0")
    private Integer fleetSize;

    private String licenseNumber;
}
