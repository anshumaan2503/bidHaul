CREATE TABLE audit_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    actor_user_id UUID,

    action VARCHAR(80) NOT NULL,

    entity_type VARCHAR(80) NOT NULL,

    entity_id UUID,

    metadata TEXT,

    event_timestamp TIMESTAMP WITH TIME ZONE NOT NULL
        DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_audit_logs_actor
        FOREIGN KEY (actor_user_id)
        REFERENCES users(id)
        ON DELETE SET NULL
);

CREATE INDEX idx_audit_logs_actor_user_id
    ON audit_logs(actor_user_id);

CREATE INDEX idx_audit_logs_entity
    ON audit_logs(entity_type, entity_id);

CREATE INDEX idx_audit_logs_timestamp
    ON audit_logs(event_timestamp);