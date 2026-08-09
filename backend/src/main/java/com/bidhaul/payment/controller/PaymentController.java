package com.bidhaul.payment.controller;

import com.bidhaul.payment.dto.request.CreatePaymentOrderRequestDto;
import com.bidhaul.payment.dto.request.VerifyPaymentRequestDto;
import com.bidhaul.payment.dto.response.PaymentOrderResponseDto;
import com.bidhaul.payment.dto.response.PaymentResponseDto;
import com.bidhaul.payment.service.PaymentService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/payments")
@RequiredArgsConstructor
public class PaymentController {

    private final PaymentService paymentService;

    @PostMapping("/orders")
    @PreAuthorize(
            "hasAnyRole('COMPANY', 'TRANSPORTER')"
    )
    public ResponseEntity<PaymentOrderResponseDto>
    createOrder(
            @Valid
            @RequestBody
            CreatePaymentOrderRequestDto request
    ) {

        return ResponseEntity
                .status(HttpStatus.CREATED)
                .body(
                        paymentService.createOrder(
                                request
                        )
                );
    }

    @PostMapping("/verify")
    @PreAuthorize(
            "hasAnyRole('COMPANY', 'TRANSPORTER')"
    )
    public ResponseEntity<PaymentResponseDto>
    verifyPayment(
            @Valid
            @RequestBody
            VerifyPaymentRequestDto request
    ) {

        return ResponseEntity.ok(
                paymentService.verifyPayment(
                        request
                )
        );
    }
}