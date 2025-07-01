# 🔗 Understanding SQL Joins – Airbnb Clone

This section explains the purpose and usage of different SQL JOIN types used in the backend of the Airbnb Clone project. JOINs are essential in relational databases for combining data from multiple tables.

---

## 🧩 1. INNER JOIN

### ✅ Description

Returns only the rows **with matching values in both tables**.

### 📌 Use Case in Project

Retrieve all bookings along with the users who made them.

### 🧪 Sample Query

```sql
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
```

### 🧠 Notes

* Bookings without a matching user will be excluded.
* Best for scenarios where a valid relationship must exist.

---

## 🧩 2. LEFT JOIN

### ✅ Description

Returns **all rows from the left table** (e.g., properties), and the matching rows from the right table (e.g., reviews). If no match, the result is NULL on the right.

### 📌 Use Case in Project

List all properties and their reviews. Include properties that have **no reviews yet**.

### 🧪 Sample Query

```sql
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
```

### 🧠 Notes

* Useful for audit, content gaps, or admin reporting.
* Allows us to identify unrated or new listings.

---

## 🧩 3. FULL OUTER JOIN

### ✅ Description

Returns **all records** when there is a match in **either** left or right table. Non-matching rows from either side are returned with NULLs.

### 📌 Use Case in Project

Retrieve **all users** and **all bookings**, including:

* Users without bookings
* Bookings not linked to a user (data issues)

### 🧪 Sample Query

```sql
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
```

### 🧠 Notes

* Very helpful in spotting orphan records or debugging relationships.
* Less commonly supported in some SQL engines but fully supported in PostgreSQL.

---


# 📦 SQL Subqueries

This section explains and includes subqueries used to retrieve advanced insights from the Airbnb Clone database using both non-correlated and correlated subqueries.

---

## 🔍 1. Non-Correlated Subquery – Properties with Average Rating > 4.0

### ✅ Query

```sql
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
```

### 💡 Logic

* This is a **non-correlated subquery**, meaning it runs independently of the outer query.
* The inner subquery returns all `property_id`s that have an average rating greater than 4.0.
* The outer query then selects full property details for those IDs.

---

## 🔄 2. Correlated Subquery – Users with More Than 3 Bookings

### ✅ Query

```sql
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
```

### 💡 Logic

* This is a **correlated subquery**, meaning it depends on each row of the outer query.
* For each user, the subquery counts how many bookings they have.
* Only users with **more than 3 bookings** are returned by the outer query.

---

# 📊 Aggregations and Window Functions – Airbnb Clone

This section explains the use of SQL aggregation and window functions to analyze data within the Airbnb Clone backend project.

---

## 🔢 1. Aggregation – Total Number of Bookings by Each User

### ✅ Query Logic

We use the `COUNT()` aggregation function to determine how many bookings each user has made.

### 🧩 SQL Summary

```sql
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
```

### 💡 Insight

* `LEFT JOIN` ensures even users with 0 bookings are included.
* Useful for analytics, leaderboard views, or understanding user activity.

---

## 🪜 2. Window Function – Rank Properties by Booking Count

### ✅ Query Logic

We use `RANK()` as a window function to assign a ranking to each property based on how many bookings it has received.

### 🧩 SQL Summary

```sql
SELECT
    p.property_id,
    p.name,
    COUNT(b.booking_id) AS total_bookings,
    RANK() OVER (ORDER BY COUNT(b.booking_id) DESC) AS booking_rank
FROM
    properties p
LEFT JOIN
    bookings b ON p.property_id = b.property_id
GROUP BY
    p.property_id, p.name
ORDER BY
    booking_rank;
```

### 💡 Insight

* `RANK()` provides meaningful ordering even when booking totals are tied.
* Supports admin dashboards or top-performer analytics.

---

## 📌 Summary

* Aggregation functions like `COUNT()` give us grouped insights over records.
* Window functions like `RANK()` help compare rows within a result set without collapsing them.

These SQL techniques are essential for reporting, recommendations, and ranking features in scalable backend systems like Airbnb.



