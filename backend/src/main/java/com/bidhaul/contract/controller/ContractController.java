package com.bidhaul.contract.controller;

import com.bidhaul.contract.dto.request.AcceptContractRequestDto;
import com.bidhaul.contract.dto.response.CompetitiveBidResponseDto;
import com.bidhaul.contract.dto.response.ContractResponseDto;
import com.bidhaul.contract.service.ContractService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1/contracts")
@RequiredArgsConstructor
public class ContractController {

    private final ContractService contractService;

    @GetMapping("/{id}")
    @PreAuthorize("hasAnyRole('COMPANY', 'TRANSPORTER')")
    public ResponseEntity<ContractResponseDto> getContract(
            @PathVariable UUID id
    ) {

        return ResponseEntity.ok(
                contractService.getContract(id)
        );
    }

    @GetMapping("/tender/{tenderId}")
    @PreAuthorize("hasAnyRole('COMPANY', 'TRANSPORTER')")
    public ResponseEntity<ContractResponseDto> getTenderContract(
            @PathVariable UUID tenderId
    ) {

        return ResponseEntity.ok(
                contractService.getTenderContract(tenderId)
        );
    }

    @GetMapping("/my")
    @PreAuthorize("hasAnyRole('COMPANY', 'TRANSPORTER')")
    public ResponseEntity<List<ContractResponseDto>> getMyContracts() {

        return ResponseEntity.ok(
                contractService.getMyContracts()
        );
    }

    @PostMapping("/{id}/accept")
    @PreAuthorize("hasRole('TRANSPORTER')")
    public ResponseEntity<ContractResponseDto> acceptContract(
            @PathVariable UUID id,
            @Valid @RequestBody AcceptContractRequestDto request
    ) {

        return ResponseEntity.ok(
                contractService.acceptContract(id, request)
        );
    }
}