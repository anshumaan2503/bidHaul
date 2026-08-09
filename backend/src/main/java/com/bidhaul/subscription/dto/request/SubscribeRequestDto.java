package com.bidhaul.subscription.dto.request;

import com.bidhaul.subscription.enums.BillingCycle;
import jakarta.validation.constraints.NotNull;
import lombok.*;

import java.util.UUID;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class SubscribeRequestDto {

    @NotNull(message = "Plan ID is required")
    private UUID planId;

    @NotNull(message = "Billing cycle is required")
    private BillingCycle billingCycle;
}