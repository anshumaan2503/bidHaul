package com.bidhaul.invoice.controller;

import com.bidhaul.invoice.dto.response.InvoiceResponseDto;
import com.bidhaul.invoice.service.InvoiceService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1/invoices")
@RequiredArgsConstructor
public class InvoiceController {

    private final InvoiceService invoiceService;

    @GetMapping("/my")
    @PreAuthorize("hasAnyRole('COMPANY', 'TRANSPORTER')")
    public ResponseEntity<List<InvoiceResponseDto>> getMyInvoices() {

        return ResponseEntity.ok(
                invoiceService.getMyInvoices()
        );
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasAnyRole('COMPANY', 'TRANSPORTER')")
    public ResponseEntity<InvoiceResponseDto> getInvoice(
            @PathVariable UUID id
    ) {

        return ResponseEntity.ok(
                invoiceService.getInvoice(id)
        );
    }

    @GetMapping("/subscription/{subscriptionId}")
    @PreAuthorize("hasAnyRole('COMPANY', 'TRANSPORTER')")
    public ResponseEntity<InvoiceResponseDto>
    getSubscriptionInvoice(
            @PathVariable UUID subscriptionId
    ) {

        return ResponseEntity.ok(
                invoiceService.getSubscriptionInvoice(
                        subscriptionId
                )
        );
    }
}