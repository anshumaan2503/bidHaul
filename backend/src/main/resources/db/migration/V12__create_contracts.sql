CREATE TABLE contracts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    contract_number VARCHAR(30) NOT NULL,

    tender_id UUID NOT NULL,
    bid_id UUID NOT NULL,
    negotiation_id UUID NOT NULL,

    company_id UUID NOT NULL,
    transporter_id UUID NOT NULL,

    final_amount NUMERIC(12, 2) NOT NULL,

    terms TEXT NOT NULL,

    status VARCHAR(30) NOT NULL DEFAULT 'PENDING_ACCEPTANCE',

    accepted_by UUID,
    accepted_at TIMESTAMP WITH TIME ZONE,

    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uk_contracts_contract_number
        UNIQUE (contract_number),

    CONSTRAINT uk_contracts_tender_id
        UNIQUE (tender_id),

    CONSTRAINT uk_contracts_negotiation_id
        UNIQUE (negotiation_id),

    CONSTRAINT fk_contracts_tender
        FOREIGN KEY (tender_id)
        REFERENCES tenders(id),

    CONSTRAINT fk_contracts_bid
        FOREIGN KEY (bid_id)
        REFERENCES bids(id),

    CONSTRAINT fk_contracts_negotiation
        FOREIGN KEY (negotiation_id)
        REFERENCES negotiations(id),

    CONSTRAINT fk_contracts_company
        FOREIGN KEY (company_id)
        REFERENCES users(id),

    CONSTRAINT fk_contracts_transporter
        FOREIGN KEY (transporter_id)
        REFERENCES users(id),

    CONSTRAINT fk_contracts_accepted_by
        FOREIGN KEY (accepted_by)
        REFERENCES users(id),

    CONSTRAINT chk_contract_final_amount
        CHECK (final_amount > 0)
);

CREATE INDEX idx_contracts_company_id
    ON contracts(company_id);

CREATE INDEX idx_contracts_transporter_id
    ON contracts(transporter_id);

CREATE INDEX idx_contracts_status
    ON contracts(status);

CREATE INDEX idx_contracts_tender_id
    ON contracts(tender_id);