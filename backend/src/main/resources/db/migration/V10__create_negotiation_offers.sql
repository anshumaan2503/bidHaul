CREATE TABLE negotiation_offers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    negotiation_id UUID NOT NULL,
    offered_by UUID NOT NULL,

    amount NUMERIC(12, 2) NOT NULL,
    remarks TEXT NOT NULL,

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_negotiation_offers_negotiation
        FOREIGN KEY (negotiation_id)
        REFERENCES negotiations(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_negotiation_offers_user
        FOREIGN KEY (offered_by)
        REFERENCES users(id),

    CONSTRAINT chk_negotiation_offer_amount
        CHECK (amount > 0)
);

CREATE INDEX idx_negotiation_offers_negotiation_id
    ON negotiation_offers(negotiation_id);

CREATE INDEX idx_negotiation_offers_offered_by
    ON negotiation_offers(offered_by);