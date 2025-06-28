# Seed Data Overview — Airbnb‑Style Backend

## 🎯 Purpose

The goal of `seed.sql` is to:

* Populate each core table (`users`, `properties`, `bookings`, etc.) with meaningful and realistic records
* Simulate the flow of data in an actual rental marketplace
* Enable quick testing and prototyping with minimal setup

---

## 📄 What's in the Script?

### 👥 Users

```sql
INSERT INTO users (...)
```

* Adds four users with distinct roles: guest, two hosts, and an admin
* Uses `uuid_generate_v4()` to assign UUIDs explicitly (though `DEFAULT` is set in schema)
* Demonstrates how `NULL` can be used for optional fields like phone\_number

### 🏠 Properties

```sql
INSERT INTO properties (...)
```

* Two properties owned by hosts Bob and Carla
* Foreign key relationships are set dynamically using subqueries:

  ```sql
  (SELECT user_id FROM users WHERE email = 'bob@example.com')
  ```
* Each property has a nightly rate and textual description

### 📅 Bookings

```sql
INSERT INTO bookings (...)
```

* Simulates a guest (Alice) booking both properties
* Includes date range, total cost, and booking status (`confirmed`, `pending`)
* Subqueries resolve FK constraints for user and property references

### 💳 Payments

```sql
INSERT INTO payments (...)
```

* One confirmed booking has a corresponding payment
* Demonstrates a 1:1 relationship between booking and payment
* Uses `SELECT booking_id ...` to fetch dynamically based on booking value

### ⭐ Reviews

```sql
INSERT INTO reviews (...)
```

* One review left by Alice for a completed stay
* Review includes rating (1–5) and textual feedback

### 💬 Messages

```sql
INSERT INTO messages (...)
```

* Demonstrates two-way communication between a guest and a host
* Highlights use of subqueries for both sender and recipient

---

## ✅ Why `uuid_generate_v4()`?

While UUIDs are auto-generated via the schema default, using `uuid_generate_v4()` explicitly:

* Makes the `INSERT` statements self-contained
* Provides clarity and control when inserting multiple rows at once
* Still ensures uniqueness even without relying on default column logic

We could omit `user_id`, `property_id`, etc., and rely on defaults — but this way we retain flexibility and portability.

---

## 🚀 How to Run

Assuming you've already run `schema.sql`:

```bash
psql -U <user> -d <your_database> -f seed.sql
or 
psql -d airbnb_backend -f seed.sql -- for default user
```

