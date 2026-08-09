package com.bidhaul.negotiation.controller;

import com.bidhaul.negotiation.dto.request.CreateNegotiationOfferRequestDto;
import com.bidhaul.negotiation.dto.request.CreateNegotiationRequestDto;
import com.bidhaul.negotiation.dto.response.NegotiationResponseDto;
import com.bidhaul.negotiation.service.NegotiationService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1/negotiations")
public class NegotiationController {

    private final NegotiationService negotiationService;

    public NegotiationController(
            NegotiationService negotiationService
    ) {
        this.negotiationService = negotiationService;
    }

    @PostMapping
    @PreAuthorize("hasRole('COMPANY')")
    public ResponseEntity<NegotiationResponseDto> createNegotiation(
            @Valid @RequestBody CreateNegotiationRequestDto request
    ) {

        return ResponseEntity
                .status(HttpStatus.CREATED)
                .body(negotiationService.createNegotiation(request));
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasAnyRole('COMPANY', 'TRANSPORTER')")
    public ResponseEntity<NegotiationResponseDto> getNegotiation(
            @PathVariable UUID id
    ) {

        return ResponseEntity.ok(
                negotiationService.getNegotiation(id)
        );
    }

    @GetMapping("/my")
    @PreAuthorize("hasAnyRole('COMPANY', 'TRANSPORTER')")
    public ResponseEntity<List<NegotiationResponseDto>>
    getMyNegotiations() {

        return ResponseEntity.ok(
                negotiationService.getMyNegotiations()
        );
    }

    @GetMapping("/tender/{tenderId}")
    @PreAuthorize("hasAnyRole('COMPANY', 'TRANSPORTER')")
    public ResponseEntity<List<NegotiationResponseDto>>
    getTenderNegotiations(
            @PathVariable UUID tenderId
    ) {

        return ResponseEntity.ok(
                negotiationService.getTenderNegotiations(tenderId)
        );
    }

    @PostMapping("/{id}/offers")
    @PreAuthorize("hasAnyRole('COMPANY', 'TRANSPORTER')")
    public ResponseEntity<NegotiationResponseDto> addOffer(
            @PathVariable UUID id,
            @Valid @RequestBody CreateNegotiationOfferRequestDto request
    ) {

        return ResponseEntity.ok(
                negotiationService.addOffer(id, request)
        );
    }

    @PostMapping("/{id}/accept")
    @PreAuthorize("hasAnyRole('COMPANY', 'TRANSPORTER')")
    public ResponseEntity<NegotiationResponseDto> acceptNegotiation(
            @PathVariable UUID id
    ) {

        return ResponseEntity.ok(
                negotiationService.acceptNegotiation(id)
        );
    }

    @PostMapping("/{id}/reject")
    @PreAuthorize("hasAnyRole('COMPANY', 'TRANSPORTER')")
    public ResponseEntity<NegotiationResponseDto> rejectNegotiation(
            @PathVariable UUID id
    ) {

        return ResponseEntity.ok(
                negotiationService.rejectNegotiation(id)
        );
    }
}