
-- -------------------------------------------------------------------
-- 1️⃣ Total number of bookings made by each user (Aggregation)
-- -------------------------------------------------------------------
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    COUNT(b.booking_id) AS total_bookings
FROM 
    users u
LEFT JOIN 
    bookings b ON u.user_id = b.user_id
GROUP BY 
    u.user_id, u.first_name, u.last_name
ORDER BY 
    total_bookings DESC;


-- -------------------------------------------------------------------
-- 2️⃣ Rank properties based on the number of bookings (Window Function)
-- -------------------------------------------------------------------
SELECT 
    property_id,
    name,
    total_bookings,
    ROW_NUMBER() OVER (ORDER BY total_bookings DESC) AS row_num,
    RANK() OVER (ORDER BY total_bookings DESC) AS booking_rank
FROM (
    SELECT 
        p.property_id,
        p.name,
        COUNT(b.booking_id) AS total_bookings
    FROM 
        properties p
    LEFT JOIN 
        bookings b ON p.property_id = b.property_id
    GROUP BY 
        p.property_id, p.name
) AS ranked_properties
ORDER BY 
    row_num;
