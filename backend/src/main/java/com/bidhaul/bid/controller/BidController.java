package com.bidhaul.bid.controller;

import com.bidhaul.bid.dto.request.CreateBidRequestDto;
import com.bidhaul.bid.dto.response.BidResponseDto;
import com.bidhaul.bid.service.BidService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1/tenders/{tenderId}/bids")
public class BidController {

    private final BidService bidService;

    public BidController(BidService bidService) {
        this.bidService = bidService;
    }

    @PostMapping
    @PreAuthorize("hasRole('TRANSPORTER')")
    public ResponseEntity<BidResponseDto> placeBid(
            @PathVariable UUID tenderId,
            @Valid @RequestBody CreateBidRequestDto request
    ) {

        return ResponseEntity
                .status(HttpStatus.CREATED)
                .body(
                        bidService.placeBid(
                                tenderId,
                                request
                        )
                );
    }

    @GetMapping
    @PreAuthorize("hasAnyRole('COMPANY', 'TRANSPORTER')")
    public ResponseEntity<List<BidResponseDto>> getTenderBids(
            @PathVariable UUID tenderId
    ) {

        return ResponseEntity.ok(
                bidService.getTenderBids(tenderId)
        );
    }
}