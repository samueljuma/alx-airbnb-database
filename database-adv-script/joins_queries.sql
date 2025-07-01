
-- Write a query using an INNER JOIN to retrieve all 
-- bookings and the respective users who made those bookings.
SELECT 
    bookings.booking_id,
    bookings.start_date,
    bookings.end_date,
    bookings.total_price,
    users.user_id,
    users.first_name,
    users.last_name,
    users.email
FROM 
    bookings
INNER JOIN 
    users ON bookings.user_id = users.user_id;


-- -------------------------------------------------------------------
-- Write a query using aLEFT JOIN to retrieve all properties 
-- and their reviews, including properties that have no reviews.
SELECT 
    properties.property_id,
    properties.name,
    reviews.review_id,
    reviews.rating,
    reviews.comment
FROM 
    properties
LEFT JOIN 
    reviews ON properties.property_id = reviews.property_id;

-- -------------------------------------------------------------------
-- Write a query using a FULL OUTER JOIN to retrieve all users 
-- and all bookings, even if the user has no booking or a 
-- booking is not linked to a user

SELECT 
    users.user_id,
    users.first_name,
    bookings.booking_id,
    bookings.start_date,
    bookings.total_price
FROM 
    users
FULL OUTER JOIN 
    bookings ON users.user_id = bookings.user_id;