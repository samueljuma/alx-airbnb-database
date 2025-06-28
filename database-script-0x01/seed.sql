-- seed.sql — Sample data population for Airbnb-style schema

-- ---------------------------------------------------------------------------
-- Users
-- ---------------------------------------------------------------------------
INSERT INTO users (user_id, first_name, last_name, email, password_hash, phone_number, role)
VALUES
  (uuid_generate_v4(), 'Alice',   'Johnson', 'alice@example.com',  'hashed_pw_1', '0700123456', 'guest'),
  (uuid_generate_v4(), 'Bob',     'Williams','bob@example.com',    'hashed_pw_2', '0700765432', 'host'),
  (uuid_generate_v4(), 'Carla',   'Smith',   'carla@example.com',  'hashed_pw_3', '0700456123', 'host'),
  (uuid_generate_v4(), 'Daniel',  'Ngugi',   'daniel@example.com', 'hashed_pw_4', NULL,         'admin');

-- ---------------------------------------------------------------------------
-- Properties
-- ---------------------------------------------------------------------------
INSERT INTO properties (property_id, host_id, name, description, location, price_per_night)
VALUES
  (uuid_generate_v4(), (SELECT user_id FROM users WHERE email = 'bob@example.com'), 'Seaside Villa', 'A cozy beach villa with ocean views.', 'Mombasa, Kenya', 120.00),
  (uuid_generate_v4(), (SELECT user_id FROM users WHERE email = 'carla@example.com'), 'Nairobi Loft', 'Modern apartment in city center.', 'Nairobi, Kenya', 85.50);

-- ---------------------------------------------------------------------------
-- Bookings
-- ---------------------------------------------------------------------------
INSERT INTO bookings (booking_id, property_id, user_id, start_date, end_date, total_price, status)
VALUES
  (
    uuid_generate_v4(),
    (SELECT property_id FROM properties WHERE name = 'Seaside Villa'),
    (SELECT user_id FROM users WHERE email = 'alice@example.com'),
    '2025-07-15', '2025-07-20',
    600.00,
    'confirmed'
  ),
  (
    uuid_generate_v4(),
    (SELECT property_id FROM properties WHERE name = 'Nairobi Loft'),
    (SELECT user_id FROM users WHERE email = 'alice@example.com'),
    '2025-08-01', '2025-08-03',
    171.00,
    'pending'
  );

-- ---------------------------------------------------------------------------
-- Payments
-- ---------------------------------------------------------------------------
INSERT INTO payments (payment_id, booking_id, amount, payment_method)
VALUES
  (
    uuid_generate_v4(),
    (SELECT booking_id FROM bookings WHERE total_price = 600.00),
    600.00,
    'credit_card'
  );

-- ---------------------------------------------------------------------------
-- Reviews
-- ---------------------------------------------------------------------------
INSERT INTO reviews (review_id, property_id, user_id, rating, comment)
VALUES
  (
    uuid_generate_v4(),
    (SELECT property_id FROM properties WHERE name = 'Seaside Villa'),
    (SELECT user_id FROM users WHERE email = 'alice@example.com'),
    5,
    'Absolutely loved the view and location!'
  );

-- ---------------------------------------------------------------------------
-- Messages
-- ---------------------------------------------------------------------------
INSERT INTO messages (message_id, sender_id, recipient_id, message_body)
VALUES
  (
    uuid_generate_v4(),
    (SELECT user_id FROM users WHERE email = 'alice@example.com'),
    (SELECT user_id FROM users WHERE email = 'bob@example.com'),
    'Hi Bob, is Seaside Villa available during August?'
  ),
  (
    uuid_generate_v4(),
    (SELECT user_id FROM users WHERE email = 'bob@example.com'),
    (SELECT user_id FROM users WHERE email = 'alice@example.com'),
    'Hi Alice, August is mostly booked but July has availability!'
  );