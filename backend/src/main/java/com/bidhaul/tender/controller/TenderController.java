package com.bidhaul.tender.controller;

import com.bidhaul.contract.dto.response.CompetitiveBidResponseDto;
import com.bidhaul.contract.dto.response.ContractResponseDto;
import com.bidhaul.contract.service.ContractService;
import com.bidhaul.tender.dto.request.CreateTenderRequestDto;
import com.bidhaul.tender.dto.response.TenderResponseDto;
import com.bidhaul.tender.service.TenderService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1/tenders")
public class TenderController {

    private final TenderService tenderService;
    private final ContractService contractService;

    public TenderController(
            TenderService tenderService,
            ContractService contractService
    ) {
        this.tenderService = tenderService;
        this.contractService = contractService;
    }

    @PostMapping
    @PreAuthorize("hasRole('COMPANY')")
    public ResponseEntity<TenderResponseDto> createTender(
            @Valid @RequestBody CreateTenderRequestDto request
    ) {

        return ResponseEntity
                .status(HttpStatus.CREATED)
                .body(tenderService.createTender(request));
    }

    @GetMapping("/{id}")
    public ResponseEntity<TenderResponseDto> getTender(
            @PathVariable UUID id
    ) {

        return ResponseEntity.ok(
                tenderService.getTender(id)
        );
    }

    @GetMapping("/my")
    @PreAuthorize("hasRole('COMPANY')")
    public ResponseEntity<List<TenderResponseDto>> getMyTenders() {

        return ResponseEntity.ok(
                tenderService.getMyTenders()
        );
    }

    @GetMapping("/live")
    @PreAuthorize("hasRole('TRANSPORTER')")
    public ResponseEntity<List<TenderResponseDto>> getLiveTenders() {

        return ResponseEntity.ok(
                tenderService.getLiveTenders()
        );
    }

    @PutMapping("/{id}/close")
    @PreAuthorize("hasRole('COMPANY')")
    public ResponseEntity<TenderResponseDto> closeTender(
            @PathVariable UUID id
    ) {

        return ResponseEntity.ok(
                tenderService.closeTender(id)
        );
    }

    @GetMapping("/{id}/competitive-statement")
    @PreAuthorize("hasRole('COMPANY')")
    public ResponseEntity<List<CompetitiveBidResponseDto>>
    getCompetitiveStatement(
            @PathVariable UUID id
    ) {

        return ResponseEntity.ok(
                contractService.getCompetitiveStatement(id)
        );
    }

    @PostMapping("/{id}/award")
    @PreAuthorize("hasRole('COMPANY')")
    public ResponseEntity<ContractResponseDto> awardTender(
            @PathVariable UUID id,
            @RequestParam UUID negotiationId,
            @RequestBody String terms
    ) {

        return ResponseEntity
                .status(HttpStatus.CREATED)
                .body(
                        contractService.awardTender(
                                id,
                                negotiationId,
                                terms
                        )
                );
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('COMPANY')")
    public ResponseEntity<Void> deleteTender(
            @PathVariable UUID id
    ) {
        tenderService.deleteTender(id);
        return ResponseEntity.noContent().build();
    }
}