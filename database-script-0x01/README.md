# Database Schema

> **Stack**: PostgreSQL 16  ·  UUID PKs  ·  Native ENUMs  ·  Full 3‑NF

---

## Why PostgreSQL?

| Reason                 | Detail                                                                             |
| ---------------------- | ---------------------------------------------------------------------------------- |
| UUID support           | Built‑in `uuid-ossp` extension for globally unique PKs.                            |
| Rich data types        | Native `ENUM`, `JSONB`, GIS support for future location work.                      |
| Mature & battle‑tested | Widely used in production for marketplace apps (e.g., Airbnb started on Postgres). |

---

## Table‑by‑Table Highlights

| Table        | Key Points                                                                                                                           |
| ------------ | ------------------------------------------------------------------------------------------------------------------------------------ |
| `users`      | Single email per user (`UNIQUE`). `role` stored as enum `role_type` for strict values: *guest, host, admin*.                         |
| `properties` | `host_id` FK with **ON DELETE CASCADE** (if a host is removed, their listings are removed too). Trigger keeps `updated_at` fresh.    |
| `bookings`   | Composite `UNIQUE(property_id, start_date, end_date)` prevents double‑booking same slot. Composite index speeds availability checks. |
| `payments`   | `booking_id` is both FK **and** `UNIQUE`, enforcing 1‑to‑1 between booking & payment.                                                |
| `reviews`    | `UNIQUE(property_id, user_id)` => one review per user per property.                                                                  |
| `messages`   | Self‑referencing FKs: `sender_id`, `recipient_id` both point to `users`. Separate indexes provide fast inbox/outbox queries.         |

---

## Constraints & Data Quality

* **CHECKs** guard money (`>= 0`), ratings (1‑5), and date order (`end_date > start_date`).
* **ENUMs** lock domain values without extra join tables, keeping queries simple.
* **Foreign Keys** all sport `ON DELETE CASCADE` to avoid orphan rows (tune per business rules).

---

## Indexing for Performance

**Indexes**
   * Email (`UNIQUE`) handles login lookups.
   * Composite `(property_id, start_date, end_date)` covers the critical “find overlapping bookings” query.
   * Sender / recipient indexes keep messaging responsive.



---

## How to Run

```bash
psql -U <user> -d <db> -f schema.sql

# Another way 
postgres --version - checks version
brew services start postgresql
createdb airbnb_backend
psql -d airbnb_backend -f schema.sql
\dt        -- list all tables
\d users   -- describe the users table
\dT --  List all enums
psql -d airbnb_backend -f seed.sql -- Add data 

```

*Requires Postgres ≥ 12 with `uuid-ossp` extension available.*

---

