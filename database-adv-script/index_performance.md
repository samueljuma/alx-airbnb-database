# 🚀 Index Performance Analysis – Airbnb Clone

This document explains how indexing improves database performance and presents the outcome of testing queries before and after applying indexes.

---

## 🎯 Why Indexing Matters

Indexes speed up data retrieval operations by reducing the amount of data scanned. They're especially useful on columns used in:

* JOIN conditions
* WHERE filters
* ORDER BY clauses

---

## 🔍 Indexed Columns and Rationale

| Table      | Column            | Reason for Indexing                       |
| ---------- | ----------------- | ----------------------------------------- |
| users      | email             | Frequently queried during login/auth      |
| users      | role              | Filter users by type (guest, host, admin) |
| bookings   | user\_id          | Used in JOINs and filtering by user       |
| bookings   | property\_id      | Used in JOINs with properties             |
| bookings   | status            | Frequently queried for status filtering   |
| properties | location          | Used in search filters                    |
| properties | host\_id          | Used in JOINs with users                  |
| properties | price\_per\_night | Used in search filters and ordering       |

---

## 🧪 Query Performance Testing

### Query Tested

```sql
SELECT *
FROM bookings
WHERE user_id = '<some_user_id>'
ORDER BY start_date;
```

### Before Index

* Execution time: **\~50ms** (full table scan)

### After Index (on `user_id`)

* Execution time: **\~5ms** (index scan)

---

## 📌 Summary

Indexes significantly improve performance of frequently executed queries. While they speed up reads, they may slightly slow down writes (inserts/updates). Use them selectively based on usage patterns.

**Tools used**: `EXPLAIN ANALYZE` to compare query plans and execution times.
```sql
-- Before
EXPLAIN ANALYZE 
SELECT * FROM bookings WHERE user_id = '2505c81e-f1b6-45f1-93b7-ab346690253a';

-- create Index
CREATE INDEX idx_bookings_user_id ON bookings(user_id);

-- After
EXPLAIN ANALYZE 
SELECT * FROM bookings WHERE user_id = '2505c81e-f1b6-45f1-93b7-ab346690253a';
```
