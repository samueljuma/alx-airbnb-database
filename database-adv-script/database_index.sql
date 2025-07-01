-- 📌 Index Creation for Airbnb Clone Backend Optimization

-- -------------------------------------------------------------------
-- Users Table Indexes
-- -------------------------------------------------------------------
-- Index on user_id for quick lookups and joins
CREATE INDEX idx_users_user_id ON users(user_id);

--Sample Checks before and after index creation
--##################################################################################
-- Index on email for quick lookup during login/authentication
-- Before
EXPLAIN ANALYZE 
SELECT * FROM bookings WHERE user_id = '2505c81e-f1b6-45f1-93b7-ab346690253a';

-- create Index
CREATE INDEX idx_bookings_user_id ON bookings(user_id);

-- After
EXPLAIN ANALYZE 
SELECT * FROM bookings WHERE user_id = '2505c81e-f1b6-45f1-93b7-ab346690253a';
--##################################################################################


-- Index on email for quick lookup during login/authentication
CREATE INDEX idx_users_email ON users(email);

-- Index on role for filtering users by type (guest, host, admin)
CREATE INDEX idx_users_role ON users(role);

-- -------------------------------------------------------------------
-- Bookings Table Indexes
-- -------------------------------------------------------------------
-- Index on user_id for joins and filtering by user
CREATE INDEX idx_bookings_user_id ON bookings(user_id);

-- Index on property_id for joins with properties
CREATE INDEX idx_bookings_property_id ON bookings(property_id);

-- Index on status to optimize booking status queries
CREATE INDEX idx_bookings_status ON bookings(status);

-- -------------------------------------------------------------------
-- Properties Table Indexes
-- -------------------------------------------------------------------
-- Index on location for filtering/search
CREATE INDEX idx_properties_location ON properties(location);

-- Index on host_id for joins and filtering
CREATE INDEX idx_properties_host_id ON properties(host_id);

-- Index on price_per_night for range queries and filtering
CREATE INDEX idx_properties_price_per_night ON properties(price_per_night);
