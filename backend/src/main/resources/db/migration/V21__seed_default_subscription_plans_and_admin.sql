-- Seed Super Admin user if not present
INSERT INTO users (id, email, password_hash, full_name, phone, user_type, status, created_at, updated_at)
VALUES (
    '00000000-0000-0000-0000-000000000001',
    'superadmin@bidhaul.com',
    '$2a$10$dXJ3SW6G7P50lGmMkkmwe.20cQQubK3.HZWzG3YB1tlRy.fqv1zui',
    'System Super Admin',
    '+18005550199',
    'SUPER_ADMIN',
    'ACTIVE',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
) ON CONFLICT (email) DO NOTHING;

-- Seed default Subscription Plans
INSERT INTO subscription_plans (id, name, monthly_price, description, features, recommended, is_active, created_at, updated_at)
VALUES 
(
    '11111111-1111-1111-1111-111111111111',
    'Starter Freight Plan',
    999.00,
    'Essential reverse bidding & load matching tools for small fleets.',
    '["10 Bids per month", "Standard Support", "Basic Analytics"]',
    FALSE,
    TRUE,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
),
(
    '22222222-2222-2222-2222-222222222222',
    'Professional Logistics Plan',
    2999.00,
    'Advanced reverse auction tools & live tracking for growing logistics operators.',
    '["Unlimited Bids", "Real-Time Tracking", "Priority Support", "Automated Invoicing"]',
    TRUE,
    TRUE,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
),
(
    '33333333-3333-3333-3333-333333333333',
    'Enterprise Fleet Plan',
    5999.00,
    'Full enterprise automation, custom integrations & 24/7 dedicated account manager.',
    '["Unlimited Bids", "Custom Integrations", "24/7 Dedicated Support", "Advanced Fleet Analytics"]',
    FALSE,
    TRUE,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
)
ON CONFLICT (name) DO NOTHING;
