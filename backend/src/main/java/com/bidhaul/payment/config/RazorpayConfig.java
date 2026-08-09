package com.bidhaul.payment.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;

@Configuration
public class RazorpayConfig {

    private final String keyId;

    private final String keySecret;

    private final String webhookSecret;

    public RazorpayConfig(

            @Value("${razorpay.key-id:${RAZORPAY_KEY_ID:rzp_test_bidhaul12345}}")
            String keyId,

            @Value("${razorpay.key-secret:${RAZORPAY_KEY_SECRET:secret_test_bidhaul12345}}")
            String keySecret,

            @Value("${razorpay.webhook-secret:${RAZORPAY_WEBHOOK_SECRET:webhook_secret_bidhaul12345}}")
            String webhookSecret

    ) {

        this.keyId = keyId;
        this.keySecret = keySecret;
        this.webhookSecret = webhookSecret;
    }

    public String getKeyId() {
        return keyId;
    }

    public String getKeySecret() {
        return keySecret;
    }

    public String getWebhookSecret() {
        return webhookSecret;
    }

    public void validateApiCredentials() {

        if (keyId == null ||
                keyId.isBlank() ||
                keySecret == null ||
                keySecret.isBlank()) {

            throw new IllegalStateException(
                    "Razorpay API credentials are not configured. " +
                            "Set RAZORPAY_KEY_ID and RAZORPAY_KEY_SECRET."
            );
        }
    }
}