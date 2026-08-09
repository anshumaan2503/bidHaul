package com.bidhaul.delivery.dto.response;

import com.bidhaul.delivery.entity.DeliveryTrackingEvent;
import com.bidhaul.delivery.enums.DeliveryStatus;

import java.time.Instant;
import java.util.UUID;

public record TrackingEventResponseDto(

        UUID id,

        UUID deliveryId,

        DeliveryStatus status,

        String location,

        String remarks,

        Instant createdAt

) {

    public static TrackingEventResponseDto from(
            DeliveryTrackingEvent event
    ) {

        return new TrackingEventResponseDto(
                event.getId(),
                event.getDelivery().getId(),
                event.getStatus(),
                event.getLocation(),
                event.getRemarks(),
                event.getCreatedAt()
        );
    }
}