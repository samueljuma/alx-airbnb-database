# Normalization
## 🔹 1. First Normal Form (1NF)
> Goal: Each column should have single values (no lists), and every row should be unique.

* All tables use UUIDs as primary keys → ensures every row is unique.

* All fields hold one value only — no lists, no arrays.


## 🔹 2. Second Normal Form (2NF)
> Goal: All attributes should depend completely on the whole primary key.

* Since each table uses a single-column primary key (e.g. user_id, property_id), we’re not at risk of partial dependencies.
* Every other column in each table is directly tied to its primary key and makes sense only in that table.

## 🔹 3. Third Normal Form (3NF)
> Goal: Attributes should depend only on the primary key — not on other columns.

| Table        | Check                                                                                                                     | Result |
| ------------ | ------------------------------------------------------------------------------------------------------------------------- | ------ |
| **User**     | `role` is not derived from any other column — just tied to the user.                                                      |  ✅  |
| **Property** | Everything (name, location, price, etc.) describes only that property.                                                    |  ✅  |
| **Booking**  | Even though we could "recalculate" `total_price`, it makes sense to store it for history (e.g., prices change over time). |  ✅  |
| **Payment**  | `amount` depends on the booking and not calculated from another column here.                                              |  ✅   |
| **Review**   | Rating and comment only depend on `review_id`.                                                                            |  ✅   |
| **Message**  | Message text and time are tied only to this message.                                                                      |  ✅   |
