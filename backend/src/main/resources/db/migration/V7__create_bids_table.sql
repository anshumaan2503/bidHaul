CREATE TABLE bids (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    bid_number VARCHAR(30) NOT NULL UNIQUE,

    tender_id UUID NOT NULL,

    transporter_id UUID NOT NULL,

    amount NUMERIC(12,2) NOT NULL,

    estimated_days INTEGER NOT NULL,

    remarks TEXT NOT NULL,

    status VARCHAR(30) NOT NULL DEFAULT 'PENDING',

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_bids_tender
        FOREIGN KEY (tender_id)
        REFERENCES tenders(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_bids_transporter
        FOREIGN KEY (transporter_id)
        REFERENCES users(id)
        ON DELETE CASCADE,

    CONSTRAINT chk_bids_amount
        CHECK (amount > 0),

    CONSTRAINT chk_bids_estimated_days
        CHECK (estimated_days > 0),

    CONSTRAINT chk_bids_status
        CHECK (status IN ('PENDING', 'ACCEPTED', 'REJECTED'))
);

CREATE INDEX idx_bids_tender_id
    ON bids(tender_id);

CREATE INDEX idx_bids_transporter_id
    ON bids(transporter_id);

CREATE INDEX idx_bids_tender_amount
    ON bids(tender_id, amount);

