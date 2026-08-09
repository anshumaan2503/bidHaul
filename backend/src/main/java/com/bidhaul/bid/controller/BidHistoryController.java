package com.bidhaul.bid.controller;

import com.bidhaul.bid.dto.response.BidResponseDto;
import com.bidhaul.bid.service.BidService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/v1/bids")
public class BidHistoryController {

    private final BidService bidService;

    public BidHistoryController(BidService bidService) {
        this.bidService = bidService;
    }

    @GetMapping("/my")
    @PreAuthorize("hasRole('TRANSPORTER')")
    public ResponseEntity<List<BidResponseDto>> getMyBids() {

        return ResponseEntity.ok(
                bidService.getMyBids()
        );
    }
}