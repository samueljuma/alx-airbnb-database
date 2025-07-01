
-- Partitioned Parent Table
CREATE TABLE bookings (
    booking_id   UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    property_id  UUID NOT NULL REFERENCES properties(property_id) ON DELETE CASCADE,
    user_id      UUID NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    start_date   DATE NOT NULL,
    end_date     DATE NOT NULL CHECK (end_date > start_date),
    total_price  NUMERIC(12,2) NOT NULL CHECK (total_price >= 0),
    status       booking_status_type NOT NULL DEFAULT 'pending',
    created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT booking_unique_period UNIQUE (property_id, start_date, end_date)
) PARTITION BY RANGE (start_date);


-- Create Partitions (e.g., by year)
CREATE TABLE bookings_2024 PARTITION OF bookings
FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');

CREATE TABLE bookings_2025 PARTITION OF bookings
FOR VALUES FROM ('2025-01-01') TO ('2026-01-01');

-- Indexes on Partitions 
CREATE INDEX idx_bookings_2024_user_id ON bookings_2024(user_id);
CREATE INDEX idx_bookings_2025_user_id ON bookings_2025(user_id);


EXPLAIN ANALYZE
SELECT * FROM bookings
WHERE start_date BETWEEN '2025-07-01' AND '2025-07-31';
