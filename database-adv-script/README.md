# 🔗 Understanding SQL Joins – Airbnb Clone

This document explains the purpose and usage of different SQL JOIN types used in the backend of the Airbnb Clone project. JOINs are essential in relational databases for combining data from multiple tables.

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

## 🗂️ Conclusion

Using JOINs strategically allows us to build powerful, efficient queries that tie together related information. Mastering them is key to backend development in any relational database system.

