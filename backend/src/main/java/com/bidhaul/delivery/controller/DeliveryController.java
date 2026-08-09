package com.bidhaul.delivery.controller;

import com.bidhaul.delivery.dto.request.AddTrackingUpdateRequestDto;
import com.bidhaul.delivery.dto.request.RateDeliveryRequestDto;
import com.bidhaul.delivery.dto.response.DeliveryResponseDto;
import com.bidhaul.delivery.dto.response.TrackingEventResponseDto;
import com.bidhaul.delivery.service.DeliveryService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1/deliveries")
@RequiredArgsConstructor
public class DeliveryController {

    private final DeliveryService deliveryService;

    @GetMapping("/my")
    @PreAuthorize("hasAnyRole('COMPANY', 'TRANSPORTER')")
    public ResponseEntity<List<DeliveryResponseDto>> getMyDeliveries() {

        return ResponseEntity.ok(
                deliveryService.getMyDeliveries()
        );
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasAnyRole('COMPANY', 'TRANSPORTER')")
    public ResponseEntity<DeliveryResponseDto> getDelivery(
            @PathVariable UUID id
    ) {

        return ResponseEntity.ok(
                deliveryService.getDelivery(id)
        );
    }

    @GetMapping("/contract/{contractId}")
    @PreAuthorize("hasAnyRole('COMPANY', 'TRANSPORTER')")
    public ResponseEntity<DeliveryResponseDto> getContractDelivery(
            @PathVariable UUID contractId
    ) {

        return ResponseEntity.ok(
                deliveryService.getContractDelivery(contractId)
        );
    }

    @GetMapping("/{id}/tracking")
    @PreAuthorize("hasAnyRole('COMPANY', 'TRANSPORTER')")
    public ResponseEntity<List<TrackingEventResponseDto>> getTrackingHistory(
            @PathVariable UUID id
    ) {

        return ResponseEntity.ok(
                deliveryService.getTrackingHistory(id)
        );
    }

    @PostMapping("/{id}/pickup")
    @PreAuthorize("hasRole('TRANSPORTER')")
    public ResponseEntity<DeliveryResponseDto> markPickedUp(
            @PathVariable UUID id,
            @Valid @RequestBody AddTrackingUpdateRequestDto request
    ) {

        return ResponseEntity.ok(
                deliveryService.markPickedUp(
                        id,
                        request
                )
        );
    }

    @PostMapping("/{id}/tracking")
    @PreAuthorize("hasRole('TRANSPORTER')")
    public ResponseEntity<TrackingEventResponseDto> addTrackingUpdate(
            @PathVariable UUID id,
            @Valid @RequestBody AddTrackingUpdateRequestDto request
    ) {

        return ResponseEntity.ok(
                deliveryService.addTrackingUpdate(
                        id,
                        request
                )
        );
    }

    @PostMapping("/{id}/delivered")
    @PreAuthorize("hasRole('TRANSPORTER')")
    public ResponseEntity<DeliveryResponseDto> markDelivered(
            @PathVariable UUID id,
            @Valid @RequestBody AddTrackingUpdateRequestDto request
    ) {

        return ResponseEntity.ok(
                deliveryService.markDelivered(
                        id,
                        request
                )
        );
    }

    @PostMapping("/{id}/confirm")
    @PreAuthorize("hasRole('COMPANY')")
    public ResponseEntity<DeliveryResponseDto> confirmDelivery(
            @PathVariable UUID id,
            @Valid @RequestBody RateDeliveryRequestDto request
    ) {

        return ResponseEntity.ok(
                deliveryService.confirmDelivery(
                        id,
                        request
                )
        );
    }
}