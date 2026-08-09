CREATE TABLE tenders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    tender_number VARCHAR(30) NOT NULL UNIQUE,

    company_id UUID NOT NULL,

    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,

    pickup_location VARCHAR(255) NOT NULL,
    delivery_location VARCHAR(255) NOT NULL,

    material_type VARCHAR(150) NOT NULL,
    vehicle_type VARCHAR(150) NOT NULL,

    weight_tons NUMERIC(12,2) NOT NULL,
    ceiling_budget NUMERIC(12,2) NOT NULL,

    status VARCHAR(30) NOT NULL DEFAULT 'LIVE',

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_tenders_company
        FOREIGN KEY (company_id)
        REFERENCES users(id)
        ON DELETE CASCADE,

    CONSTRAINT chk_tenders_weight
        CHECK (weight_tons > 0),

    CONSTRAINT chk_tenders_budget
        CHECK (ceiling_budget > 0),

    CONSTRAINT chk_tenders_status
        CHECK (status IN ('DRAFT', 'LIVE', 'COMPLETED', 'CANCELLED'))
);

CREATE INDEX idx_tenders_company_id
    ON tenders(company_id);

CREATE INDEX idx_tenders_status
    ON tenders(status);