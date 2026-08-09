ALTER TABLE tenders DROP CONSTRAINT IF EXISTS chk_tenders_status;

ALTER TABLE tenders ADD CONSTRAINT chk_tenders_status
    CHECK (status IN (
        'DRAFT',
        'LIVE',
        'COMPLETED',
        'AWARDED',
        'CONTRACT_PENDING',
        'CONTRACT_ACCEPTED',
        'IN_TRANSIT',
        'COMPLETED_DELIVERY',
        'CANCELLED'
    ));
