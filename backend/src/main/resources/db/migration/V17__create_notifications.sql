CREATE TABLE notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    user_id UUID NOT NULL,

    type VARCHAR(30) NOT NULL,

    title VARCHAR(200) NOT NULL,

    message TEXT NOT NULL,

    is_read BOOLEAN NOT NULL DEFAULT FALSE,

    read_at TIMESTAMP WITH TIME ZONE,

    reference_type VARCHAR(50),

    reference_id UUID,

    created_at TIMESTAMP WITH TIME ZONE NOT NULL
        DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP WITH TIME ZONE NOT NULL
        DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_notifications_user
        FOREIGN KEY (user_id)
        REFERENCES users(id),

    CONSTRAINT chk_notifications_type
        CHECK (
            type IN (
                'SYSTEM',
                'TENDER',
                'BID',
                'NEGOTIATION',
                'CONTRACT',
                'DELIVERY',
                'SUBSCRIPTION',
                'INVOICE',
                'PAYMENT'
            )
        )
);

CREATE INDEX idx_notifications_user_id
    ON notifications(user_id);

CREATE INDEX idx_notifications_user_read
    ON notifications(user_id, is_read);

CREATE INDEX idx_notifications_created_at
    ON notifications(created_at);

CREATE INDEX idx_notifications_reference
    ON notifications(reference_type, reference_id);