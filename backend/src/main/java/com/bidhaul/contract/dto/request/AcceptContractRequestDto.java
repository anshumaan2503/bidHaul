package com.bidhaul.contract.dto.request;

import jakarta.validation.constraints.AssertTrue;

public record AcceptContractRequestDto(

        @AssertTrue(message = "Contract acceptance must be explicitly confirmed")
        boolean accepted

) {
}