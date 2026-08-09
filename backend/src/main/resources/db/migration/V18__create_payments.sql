CREATE TABLE payments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    user_id UUID NOT NULL,

    invoice_id UUID NOT NULL,

    razorpay_order_id VARCHAR(100) NOT NULL,

    razorpay_payment_id VARCHAR(100),

    amount NUMERIC(12, 2) NOT NULL,

    currency VARCHAR(3) NOT NULL DEFAULT 'INR',

    status VARCHAR(30) NOT NULL DEFAULT 'CREATED',

    razorpay_signature VARCHAR(128),

    signature_verified BOOLEAN NOT NULL DEFAULT FALSE,

    captured_at TIMESTAMP WITH TIME ZONE,

    created_at TIMESTAMP WITH TIME ZONE NOT NULL
        DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP WITH TIME ZONE NOT NULL
        DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uk_payments_razorpay_order_id
        UNIQUE (razorpay_order_id),

    CONSTRAINT uk_payments_razorpay_payment_id
        UNIQUE (razorpay_payment_id),

    CONSTRAINT fk_payments_user
        FOREIGN KEY (user_id)
        REFERENCES users(id),

    CONSTRAINT fk_payments_invoice
        FOREIGN KEY (invoice_id)
        REFERENCES invoices(id),

    CONSTRAINT chk_payments_amount
        CHECK (amount >= 0),

    CONSTRAINT chk_payments_currency
        CHECK (currency = 'INR'),

    CONSTRAINT chk_payments_status
        CHECK (
            status IN (
                'CREATED',
                'AUTHORIZED',
                'CAPTURED',
                'FAILED',
                'CANCELLED'
            )
        )
);

CREATE INDEX idx_payments_user_id
    ON payments(user_id);

CREATE INDEX idx_payments_invoice_id
    ON payments(invoice_id);

CREATE INDEX idx_payments_status
    ON payments(status);

CREATE INDEX idx_payments_created_at
    ON payments(created_at);