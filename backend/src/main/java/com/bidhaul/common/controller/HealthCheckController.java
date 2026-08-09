package com.bidhaul.common.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.Instant;
import java.util.Map;

/**
 * HealthCheckController
 *
 * Public health check endpoint for uptime monitoring bots (UptimeRobot, Cron-job.org)
 * to keep the Render backend service active and prevent cold starts/sleep.
 */
@RestController
@RequestMapping
public class HealthCheckController {

    @GetMapping({"/health", "/api/v1/health"})
    public ResponseEntity<Map<String, Object>> healthCheck() {
        return ResponseEntity.ok(Map.of(
            "status", "UP",
            "service", "BidHaul Backend API",
            "timestamp", Instant.now().toString(),
            "message", "BidHaul backend service is active and healthy."
        ));
    }
}
