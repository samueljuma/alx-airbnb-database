-- schema.sql — Production‑ready core schema for the Airbnb clone (PostgreSQL)

-- ---------------------------------------------------------------------------
-- Extensions
-- ---------------------------------------------------------------------------
-- uuid‑ossp gives us uuid_generate_v4() for primary keys
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ---------------------------------------------------------------------------
-- Enumerated types
-- ---------------------------------------------------------------------------
CREATE TYPE role_type           AS ENUM ('guest', 'host', 'admin');
CREATE TYPE booking_status_type AS ENUM ('pending', 'confirmed', 'canceled');
CREATE TYPE payment_method_type AS ENUM ('credit_card', 'paypal', 'stripe');

-- ---------------------------------------------------------------------------
-- Users
-- ---------------------------------------------------------------------------
CREATE TABLE users (
    user_id       UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    first_name    VARCHAR(50)      NOT NULL,
    last_name     VARCHAR(50)      NOT NULL,
    email         VARCHAR(255)     NOT NULL UNIQUE,
    password_hash VARCHAR(255)     NOT NULL,
    phone_number  VARCHAR(20),
    role          role_type        NOT NULL DEFAULT 'guest',
    created_at    TIMESTAMPTZ      NOT NULL DEFAULT NOW()
);

-- ---------------------------------------------------------------------------
-- Properties
-- ---------------------------------------------------------------------------
CREATE TABLE properties (
    property_id     UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    host_id         UUID            NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    name            VARCHAR(120)    NOT NULL,
    description     TEXT            NOT NULL,
    location        VARCHAR(255)    NOT NULL,
    price_per_night NUMERIC(10,2)   NOT NULL CHECK (price_per_night >= 0),
    created_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW()
);

-- Automatically update updated_at on modification
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_properties_updated
BEFORE UPDATE ON properties
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- ---------------------------------------------------------------------------
-- Bookings
-- ---------------------------------------------------------------------------
CREATE TABLE bookings (
    booking_id   UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    property_id  UUID            NOT NULL REFERENCES properties(property_id) ON DELETE CASCADE,
    user_id      UUID            NOT NULL REFERENCES users(user_id)      ON DELETE CASCADE,
    start_date   DATE            NOT NULL,
    end_date     DATE            NOT NULL CHECK (end_date > start_date),
    total_price  NUMERIC(12,2)   NOT NULL CHECK (total_price >= 0),
    status       booking_status_type NOT NULL DEFAULT 'pending',
    created_at   TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    -- prevent overlapping bookings for the same property / period if business requires
    CONSTRAINT booking_unique_period UNIQUE (property_id, start_date, end_date)
);
-- Helpful composite index for date‑range searches
CREATE INDEX idx_booking_property_dates ON bookings(property_id, start_date, end_date);

-- ---------------------------------------------------------------------------
-- Payments
-- ---------------------------------------------------------------------------
CREATE TABLE payments (
    payment_id     UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    booking_id     UUID UNIQUE  NOT NULL REFERENCES bookings(booking_id) ON DELETE CASCADE,
    amount         NUMERIC(12,2)   NOT NULL CHECK (amount >= 0),
    payment_date   TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    payment_method payment_method_type NOT NULL
);

-- ---------------------------------------------------------------------------
-- Reviews
-- ---------------------------------------------------------------------------
CREATE TABLE reviews (
    review_id   UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    property_id UUID        NOT NULL REFERENCES properties(property_id) ON DELETE CASCADE,
    user_id     UUID        NOT NULL REFERENCES users(user_id)      ON DELETE CASCADE,
    rating      INTEGER     NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment     TEXT        NOT NULL,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT unique_property_user_review UNIQUE (property_id, user_id)
);
-- Quick lookup by property
CREATE INDEX idx_reviews_property_id ON reviews(property_id);

-- ---------------------------------------------------------------------------
-- Messages
-- ---------------------------------------------------------------------------
CREATE TABLE messages (
    message_id    UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    sender_id     UUID NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    recipient_id  UUID NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    message_body  TEXT NOT NULL,
    sent_at       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
-- Indexes for sender/recipient inbox performance
CREATE INDEX idx_messages_sender_id    ON messages(sender_id);
CREATE INDEX idx_messages_recipient_id ON messages(recipient_id);

-- ---------------------------------------------------------------------------
-- Additional Indexes & Housekeeping
-- ---------------------------------------------------------------------------
-- Already covered: users.email (unique), payments.booking_id (unique)
-- Primary keys create indexes automatically.

-- End of schema.sql
