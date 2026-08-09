CREATE TABLE negotiations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    tender_id UUID NOT NULL,
    bid_id UUID NOT NULL,
    company_id UUID NOT NULL,
    transporter_id UUID NOT NULL,

    status VARCHAR(20) NOT NULL DEFAULT 'OPEN',

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_negotiation_tender
        FOREIGN KEY (tender_id)
        REFERENCES tenders(id),

    CONSTRAINT fk_negotiation_bid
        FOREIGN KEY (bid_id)
        REFERENCES bids(id),

    CONSTRAINT fk_negotiation_company
        FOREIGN KEY (company_id)
        REFERENCES users(id),

    CONSTRAINT fk_negotiation_transporter
        FOREIGN KEY (transporter_id)
        REFERENCES users(id),

    CONSTRAINT uq_negotiation_bid
        UNIQUE (bid_id)
);

CREATE INDEX idx_negotiations_tender_id
    ON negotiations(tender_id);

CREATE INDEX idx_negotiations_company_id
    ON negotiations(company_id);

CREATE INDEX idx_negotiations_transporter_id
    ON negotiations(transporter_id);