
[database_readme.md](https://github.com/user-attachments/files/22052477/database_readme.md)
# ALX Airbnb Database Project

## Directory Structure
```
alx-airbnb-database/
└── database-script-0x01/
    ├── schema.sql
    └── README.md
```

## Project Overview
This project contains the **Airbnb-like database schema** for the ALX Back-End Development program. The schema is designed following **database normalization principles up to 3NF**, ensuring minimal redundancy and optimized performance.

The schema supports users, properties, bookings, reviews, and amenities.

## Tables Description

### 1. Users
- **Purpose:** Store registered users (hosts and guests).
- **Key Columns:** `UserID` (PK), `FirstName`, `LastName`, `Email`, `PhoneNumber`.
- **Indexes:** `Email` for fast lookup.

### 2. Properties
- **Purpose:** Store property listings.
- **Key Columns:** `PropertyID` (PK), `OwnerID` (FK to Users), `PropertyName`, `PropertyType`, `PropertyLocation`, `PricePerNight`.
- **Indexes:** `PropertyLocation` for location-based queries.

### 3. Bookings
- **Purpose:** Track user bookings for properties.
- **Key Columns:** `BookingID` (PK), `UserID` (FK to Users), `PropertyID` (FK to Properties), `CheckIn`, `CheckOut`, `TotalPrice`.
- **Indexes:** `UserID`, `PropertyID` for faster queries.
- **Constraints:** `CheckOut > CheckIn`.

### 4. Reviews
- **Purpose:** Store user reviews for bookings.
- **Key Columns:** `ReviewID` (PK), `BookingID` (FK to Bookings), `Rating`, `Comment`.
- **Indexes:** `BookingID`.
- **Constraints:** `Rating` must be between 1 and 5.

### 5. Amenities
- **Purpose:** Store a list of available amenities.
- **Key Columns:** `AmenityID` (PK), `AmenityName` (Unique).

### 6. PropertyAmenities
- **Purpose:** Link properties to amenities (many-to-many).
- **Key Columns:** Composite PK (`PropertyID`, `AmenityID`), FKs to `Properties` and `Amenities`.

## Usage Instructions
1. Clone the repository:
```bash
git clone https://github.com/<your-username>/alx-airbnb-database.git
cd alx-airbnb-database/database-script-0x01
```

2. Execute the SQL script to create the schema:
```sql
-- Using psql (PostgreSQL)
\psql -U <your-db-username> -d <database-name> -f schema.sql
```

3. Verify tables:
```sql
\d
```

## ER Diagram
The schema can be represented with the following entities and relationships:
- Users (1) ↔ (M) Properties
- Users (1) ↔ (M) Bookings
- Properties (1) ↔ (M) Bookings
- Bookings (1) ↔ (1) Reviews
- Properties (M) ↔ (M) Amenities via PropertyAmenities

## Notes
- All tables are in **3NF**.
- Foreign keys ensure referential integrity.
- Indexes improve query performance.
- Constraints ensure data validity.

