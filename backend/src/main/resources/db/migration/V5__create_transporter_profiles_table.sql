CREATE TABLE transporter_profiles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL UNIQUE,
    company_name VARCHAR(255) NOT NULL,
    vehicle_type VARCHAR(100) NOT NULL,
    fleet_size INT NOT NULL DEFAULT 0,
    license_number VARCHAR(100) UNIQUE,
    completed_deliveries INT NOT NULL DEFAULT 0,
    rating NUMERIC(3, 2),
    verification_status VARCHAR(50) NOT NULL DEFAULT 'PENDING',
    rejection_reason TEXT,
    submitted_at TIMESTAMP WITH TIME ZONE,
    verified_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_transporter_profiles_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT chk_transporter_fleet_size CHECK (fleet_size >= 0),
    CONSTRAINT chk_transporter_deliveries CHECK (completed_deliveries >= 0),
    CONSTRAINT chk_transporter_rating CHECK (rating IS NULL OR (rating >= 0.00 AND rating <= 5.00))
);

CREATE INDEX idx_transporter_profiles_status ON transporter_profiles(verification_status);
