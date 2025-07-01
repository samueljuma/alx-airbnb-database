# 🚀 Partitioning Performance Report – Bookings Table

This document summarizes the implementation and performance impact of partitioning the `bookings` table based on the `start_date` column.

---

## 🎯 Objective

To improve query performance for a large `bookings` table by applying **range partitioning** on the `start_date` column.

---

## 🛠️ Implementation Summary

1. **Table Renaming and Recreation:**

   * The original `bookings` table was renamed to `bookings_old` to preserve existing data.
   * A new partitioned `bookings` table was created using `PARTITION BY RANGE (start_date)`.

2. **Child Partitions:**

   * `bookings_2024` for dates from `2024-01-01` to `2025-01-01`
   * `bookings_2025` for dates from `2025-01-01` to `2026-01-01`

3. **Data Migration:**

   * Existing data was inserted from `bookings_old` into the new partitioned structure.

4. **Indexes:**

   * Indexes were created on `user_id` for both child partitions.

5. **Test Query:**

```sql
SELECT * FROM bookings
WHERE start_date BETWEEN '2025-07-01' AND '2025-07-31';
```

---

## ⚙️ Performance Observations

* **Before Partitioning:**

  * Full table scan of `bookings`
  * Higher I/O cost, slower retrieval

* **After Partitioning:**

  * Partition pruning ensured only `bookings_2025` was scanned
  * Reduced number of scanned rows
  * Significantly faster execution
  * Index usage was more efficient due to smaller partition size

### 📈 EXPLAIN ANALYZE Summary

| Metric            | Before Partitioning | After Partitioning  |
| ----------------- | ------------------- | ------------------- |
| Scanned Rows      | High (entire table) | Low (one partition) |
| Execution Time    | Longer              | Shorter             |
| Partition Pruning | ❌ No                | ✅ Yes               |

---

## 📌 Conclusion

Partitioning the `bookings` table by `start_date` led to a measurable improvement in query performance for date-based filters. This strategy enhances scalability and responsiveness in production systems.

