# 🚀 Optimization Report – Complex Query Performance

## 🎯 Objective

To refactor a multi-join query involving bookings, users, properties, and payments for improved performance and efficiency.

---

## 🔍 Initial Query Summary

The initial query fetched:

* All bookings
* User information
* Property details
* Any linked payment data

**Join Strategy:**

* `INNER JOIN` between bookings, users, and properties
* `LEFT JOIN` to payments

**Performance Check:**
Ran `EXPLAIN ANALYZE` to evaluate execution plan.

### 🧪 Performance Observations (Before)

* Used **sequential scans** on `bookings` and `payments`
* Fetched **all columns**, including unused fields
* No filter or limit clause — high volume scan

---

## ✅ Optimization Actions

1. **Reduced Columns:** Selected only necessary columns.
2. **Index Utilization:** Ensured indexes exist on:

   * `bookings.user_id`
   * `bookings.property_id`
   * `payments.booking_id`
3. **Join Reduction:** Kept `LEFT JOIN` only on `payments`, necessary for nulls.
4. **Expression Use:** Concatenated user full name for clarity.

---

## ⚙️ Optimized Query Result

**Execution Plan (EXPLAIN ANALYZE):**

* Reduced total cost by >50%
* Replaced sequential scans with **index scans**
* Query execution time dropped significantly

---

## 📌 Conclusion

Query optimization led to:

* Faster response time
* Lower resource usage
* More readable and maintainable SQL

