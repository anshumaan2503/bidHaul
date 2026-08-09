ALTER TABLE negotiations
    ADD COLUMN final_amount NUMERIC(12, 2),
    ADD COLUMN accepted_by UUID,
    ADD COLUMN closed_at TIMESTAMP WITH TIME ZONE;