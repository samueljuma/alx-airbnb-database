
-- Write a query to find all properties where the 
-- average rating is greater than 4.0 using a subquery.
SELECT
    property_id,
    name,
    location
FROM
    properties
WHERE
    property_id IN (
        SELECT
            property_id
        FROM
            reviews
        GROUP BY
            property_id
        HAVING
            AVG(rating) > 4.0
    );


-- Write a correlated subquery to find users 
-- who have made more than 3 bookings.
SELECT
    user_id,
    first_name,
    last_name,
    email
FROM
    users u
WHERE
    (
        SELECT COUNT(*)
        FROM bookings b
        WHERE b.user_id = u.user_id
    ) > 3;