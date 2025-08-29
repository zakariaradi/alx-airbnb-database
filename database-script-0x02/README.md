
[seed_readme.md](https://github.com/user-attachments/files/22052556/seed_readme.md)
# Airbnb Database Seed Data

## Directory Structure
```
alx-airbnb-database/
└── database-script-0x02/
    ├── seed.sql
    └── README.md
```

## Overview
This directory contains SQL scripts to populate the Airbnb database with **sample data**. The data simulates real-world usage including multiple users, properties, bookings, reviews, and amenities.

## Tables Seeded
- **Users:** Sample guests and hosts.
- **Properties:** Property listings linked to owners.
- **Bookings:** User bookings for properties.
- **Reviews:** User reviews for bookings.
- **Amenities:** List of amenities.
- **PropertyAmenities:** Many-to-many relationship between properties and amenities.

## Usage Instructions
1. Ensure the database schema from `database-script-0x01/schema.sql` is created.
2. Navigate to this directory:
```bash
cd alx-airbnb-database/database-script-0x02
```
3. Run the seed script (PostgreSQL example):
```sql
\psql -U <username> -d <database-name> -f seed.sql
```
4. Verify the inserted data:
```sql
SELECT * FROM Users;
SELECT * FROM Properties;
SELECT * FROM Bookings;
```

## Notes
- The sample data is designed for testing queries and development.
- You can add more data or modify as needed for further scenarios.

