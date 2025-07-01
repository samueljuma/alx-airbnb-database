-- 🧪 Performance Testing: Full Join Query with EXPLAIN Analysis

-- -------------------------------------------------------------------
-- 🔍 Initial (Unoptimized) Query
-- -------------------------------------------------------------------
EXPLAIN 
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    p.property_id,
    p.name AS property_name,
    p.location,
    pay.payment_id,
    pay.amount,
    pay.payment_method
FROM 
    bookings b
JOIN users u ON b.user_id = u.user_id
JOIN properties p ON b.property_id = p.property_id
LEFT JOIN payments pay ON b.booking_id = pay.booking_id;


-- -------------------------------------------------------------------
-- ✅ Optimized Version
-- Optimization Tactics:
-- 1. Select only necessary columns
-- 2. Ensure indexes exist on b.user_id, b.property_id, pay.booking_id
-- 3. Use LEFT JOIN only where needed
-- -------------------------------------------------------------------
EXPLAIN 
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.status,
    b.total_price,
    u.first_name || ' ' || u.last_name AS guest_name,
    u.email,
    p.name AS property_name,
    pay.amount AS payment_amount
FROM 
    bookings b
JOIN users u ON b.user_id = u.user_id
JOIN properties p ON b.property_id = p.property_id
LEFT JOIN payments pay ON b.booking_id = pay.booking_id;
