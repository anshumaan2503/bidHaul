CREATE TABLE deliveries (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    contract_id UUID NOT NULL,
    company_id UUID NOT NULL,
    transporter_id UUID NOT NULL,

    pickup_location VARCHAR(255) NOT NULL,
    delivery_location VARCHAR(255) NOT NULL,

    status VARCHAR(30) NOT NULL DEFAULT 'PENDING_PICKUP',

    picked_up_at TIMESTAMP WITH TIME ZONE,
    delivered_at TIMESTAMP WITH TIME ZONE,
    confirmed_at TIMESTAMP WITH TIME ZONE,

    rating NUMERIC(3, 2),

    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uk_deliveries_contract_id
        UNIQUE (contract_id),

    CONSTRAINT fk_deliveries_contract
        FOREIGN KEY (contract_id)
        REFERENCES contracts(id),

    CONSTRAINT fk_deliveries_company
        FOREIGN KEY (company_id)
        REFERENCES users(id),

    CONSTRAINT fk_deliveries_transporter
        FOREIGN KEY (transporter_id)
        REFERENCES users(id),

    CONSTRAINT chk_deliveries_rating
        CHECK (
            rating IS NULL
            OR (
                rating >= 0.00
                AND rating <= 5.00
            )
        )
);

CREATE INDEX idx_deliveries_company_id
    ON deliveries(company_id);

CREATE INDEX idx_deliveries_transporter_id
    ON deliveries(transporter_id);

CREATE INDEX idx_deliveries_status
    ON deliveries(status);


CREATE TABLE delivery_tracking_events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    delivery_id UUID NOT NULL,

    status VARCHAR(30) NOT NULL,

    location VARCHAR(255) NOT NULL,

    remarks TEXT,

    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_tracking_delivery
        FOREIGN KEY (delivery_id)
        REFERENCES deliveries(id)
        ON DELETE CASCADE
);

CREATE INDEX idx_delivery_tracking_delivery_id
    ON delivery_tracking_events(delivery_id);

CREATE INDEX idx_delivery_tracking_created_at
    ON delivery_tracking_events(created_at);