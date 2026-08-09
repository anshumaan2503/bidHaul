package com.bidhaul.company.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UpdateCompanyProfileRequestDto {

    @NotBlank(message = "Company name is required")
    private String companyName;

    private String address;

    private String gstNumber;

    private String licenseNumber;
}
