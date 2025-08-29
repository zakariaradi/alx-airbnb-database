# Database Normalization to 3NF

## Initial Schema

**Bookings Table (Unnormalized)**

| BookingID | UserName | UserEmail                               | PropertyName | PropertyLocation | CheckIn    | CheckOut   | PricePerNight |
| --------- | -------- | --------------------------------------- | ------------ | ---------------- | ---------- | ---------- | ------------- |
| 1         | Alice    | [alice@mail.com](mailto:alice@mail.com) | Cozy Cottage | Paris            | 2025-09-01 | 2025-09-05 | 100           |
| 2         | Bob      | [bob@mail.com](mailto:bob@mail.com)     | Sea View Apt | Nice             | 2025-09-02 | 2025-09-06 | 150           |

**Problems:**

1. Repetition of user information and property information.
2. Data redundancy.
3. Risk of update anomalies.

---

## Step 1: First Normal Form (1NF)

**Rule:** Eliminate repeating groups; ensure each field contains atomic values.

**Tables after 1NF:**

**Users Table**

| UserID | UserName | UserEmail |
| ------ | -------- | --------- |

**Properties Table**

| PropertyID | PropertyName | PropertyLocation | PricePerNight |
| ---------- | ------------ | ---------------- | ------------- |

**Bookings Table**
\| BookingID | UserID | PropertyID | CheckIn | CheckOut |

✅ Atomic values and repeating groups removed.

---

## Step 2: Second Normal Form (2NF)

**Rule:** Remove partial dependencies; non-key columns must depend on the whole primary key.

* Bookings primary key is BookingID (single column) → no partial dependency.
* Users and Properties are simple tables → 2NF satisfied.

✅ Schema now in 2NF.

---

## Step 3: Third Normal Form (3NF)

**Rule:** Remove transitive dependencies; non-key columns must depend only on the primary key.

* Properties: `PricePerNight` depends on `PropertyID` → OK.
* Users: `UserEmail` depends on `UserID` → OK.

✅ Schema is now in 3NF.

---

## Final 3NF Schema

**Users Table**

```sql
CREATE TABLE Users (
    UserID SERIAL PRIMARY KEY,
    UserName VARCHAR(100) NOT NULL,
    UserEmail VARCHAR(100) NOT NULL UNIQUE
);
```

**Properties Table**

```sql
CREATE TABLE Properties (
    PropertyID SERIAL PRIMARY KEY,
    PropertyName VARCHAR(100) NOT NULL,
    PropertyLocation VARCHAR(100),
    PricePerNight DECIMAL(10,2) NOT NULL
);
```

**Bookings Table**

```sql
CREATE TABLE Bookings (
    BookingID SERIAL PRIMARY KEY,
    UserID INT NOT NULL REFERENCES Users(UserID),
    PropertyID INT NOT NULL REFERENCES Properties(PropertyID),
    CheckIn DATE NOT NULL,
    CheckOut DATE NOT NULL
);
```

---

## Explanation of Normalization Steps

1. **1NF:** Removed repeating groups and ensured atomic values. Split Users and Properties into separate tables.
2. **2NF:** Ensured all non-key attributes are fully functionally dependent on the primary key.
3. **3NF:** Removed transitive dependencies. All non-key columns depend only on the primary key.

**Benefits:**

* Eliminates redundancy.
* Prevents update anomalies.
* Makes database maintenance easier and more efficient.

