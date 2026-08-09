CREATE TABLE invoices (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    invoice_number VARCHAR(40) NOT NULL,

    user_id UUID NOT NULL,

    subscription_id UUID NOT NULL,

    amount NUMERIC(12, 2) NOT NULL,

    status VARCHAR(20) NOT NULL DEFAULT 'PENDING',

    billing_period VARCHAR(20) NOT NULL,

    issued_at TIMESTAMP WITH TIME ZONE NOT NULL,

    due_at TIMESTAMP WITH TIME ZONE,

    paid_at TIMESTAMP WITH TIME ZONE,

    payment_order_reference VARCHAR(100),

    payment_reference VARCHAR(100),

    created_at TIMESTAMP WITH TIME ZONE NOT NULL
        DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP WITH TIME ZONE NOT NULL
        DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uk_invoices_invoice_number
        UNIQUE (invoice_number),

    CONSTRAINT fk_invoices_user
        FOREIGN KEY (user_id)
        REFERENCES users(id),

    CONSTRAINT fk_invoices_subscription
        FOREIGN KEY (subscription_id)
        REFERENCES user_subscriptions(id),

    CONSTRAINT chk_invoices_amount
        CHECK (amount >= 0),

    CONSTRAINT chk_invoices_status
        CHECK (
            status IN (
                'PENDING',
                'PAID',
                'FAILED',
                'CANCELLED'
            )
        ),

    CONSTRAINT chk_invoices_billing_period
        CHECK (
            billing_period IN (
                'Monthly',
                'Annual'
            )
        )
);

CREATE INDEX idx_invoices_user_id
    ON invoices(user_id);

CREATE INDEX idx_invoices_subscription_id
    ON invoices(subscription_id);

CREATE INDEX idx_invoices_status
    ON invoices(status);

CREATE INDEX idx_invoices_issued_at
    ON invoices(issued_at);