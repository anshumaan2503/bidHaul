CREATE TABLE subscription_plans (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    name VARCHAR(100) NOT NULL,

    monthly_price NUMERIC(12, 2) NOT NULL,

    description TEXT NOT NULL,

    features TEXT NOT NULL,

    recommended BOOLEAN NOT NULL DEFAULT FALSE,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uk_subscription_plans_name
        UNIQUE (name),

    CONSTRAINT chk_subscription_plans_monthly_price
        CHECK (monthly_price >= 0)
);


CREATE INDEX idx_subscription_plans_active
    ON subscription_plans(is_active);


CREATE TABLE user_subscriptions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    user_id UUID NOT NULL,

    plan_id UUID NOT NULL,

    billing_cycle VARCHAR(20) NOT NULL,

    status VARCHAR(30) NOT NULL DEFAULT 'PENDING_PAYMENT',

    price_at_subscription NUMERIC(12, 2) NOT NULL,

    starts_at TIMESTAMP WITH TIME ZONE,

    expires_at TIMESTAMP WITH TIME ZONE,

    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_user_subscriptions_user
        FOREIGN KEY (user_id)
        REFERENCES users(id),

    CONSTRAINT fk_user_subscriptions_plan
        FOREIGN KEY (plan_id)
        REFERENCES subscription_plans(id),

    CONSTRAINT chk_user_subscriptions_billing_cycle
        CHECK (
            billing_cycle IN ('MONTHLY', 'ANNUAL')
        ),

    CONSTRAINT chk_user_subscriptions_status
        CHECK (
            status IN (
                'PENDING_PAYMENT',
                'ACTIVE',
                'EXPIRED',
                'CANCELLED'
            )
        ),

    CONSTRAINT chk_user_subscriptions_price
        CHECK (
            price_at_subscription >= 0
        )
);


CREATE INDEX idx_user_subscriptions_user_id
    ON user_subscriptions(user_id);


CREATE INDEX idx_user_subscriptions_status
    ON user_subscriptions(status);


CREATE INDEX idx_user_subscriptions_expiry
    ON user_subscriptions(expires_at);


CREATE UNIQUE INDEX uk_user_subscriptions_active_user
    ON user_subscriptions(user_id)
    WHERE status = 'ACTIVE';


CREATE UNIQUE INDEX uk_user_subscriptions_pending_user
    ON user_subscriptions(user_id)
    WHERE status = 'PENDING_PAYMENT';