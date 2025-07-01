# 📊 Database Performance Monitoring & Refinement Report – Airbnb Clone

This document outlines the continuous monitoring and refinement practices applied to optimize database performance in the Airbnb Clone backend project.

---

## 🎯 Objective

To improve and sustain query efficiency by:

* Monitoring high-usage queries
* Identifying performance bottlenecks
* Implementing schema/index improvements
* Documenting observed gains

---

## 🔍 Monitoring Tools Used

* **EXPLAIN ANALYZE**: Used to analyze query execution plans and understand costs.
* **pg\_stat\_statements** (PostgreSQL extension): Tracks query statistics (if enabled).

---

## 🧪 Monitored Queries

### 1. Bookings with User and Property Info

```sql
EXPLAIN ANALYZE
SELECT b.booking_id, u.first_name, p.name, b.total_price
FROM bookings b
JOIN users u ON b.user_id = u.user_id
JOIN properties p ON b.property_id = p.property_id
WHERE b.status = 'confirmed' AND b.start_date >= CURRENT_DATE;
```

**Observation:**

* Moderate cost due to full table scans and filter conditions.

**Improvement:**

* Added composite index on `(status, start_date)` in `bookings`.

```sql
CREATE INDEX idx_booking_status_date ON bookings (status, start_date);
```

**Result:**

* Query plan switched to index scan.
* Execution time dropped significantly.

---

### 2. Property Reviews

```sql
EXPLAIN ANALYZE
SELECT p.name, r.rating, r.comment
FROM properties p
LEFT JOIN reviews r ON p.property_id = r.property_id
ORDER BY p.name;
```

**Observation:**

* Sequential scan on `reviews`.

**Improvement:**

* Added index on `reviews.property_id` to support join filter.

```sql
CREATE INDEX idx_reviews_property ON reviews(property_id);
```

**Result:**

* Improved join performance.
* Lowered I/O cost and query latency.

---

## ⚙️ Summary of Improvements

| Query                              | Bottleneck    | Fix Applied                            | Performance Gain  |
| ---------------------------------- | ------------- | -------------------------------------- | ----------------- |
| Bookings + Users + Properties Join | Filter + Scan | Composite Index on `status,start_date` | Faster filtering  |
| Properties + Reviews Join          | Join Scan     | Index on `reviews.property_id`         | Reduced scan time |

---
