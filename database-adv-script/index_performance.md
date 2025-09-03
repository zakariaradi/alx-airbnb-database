
# Index Performance Analysis

This document analyzes the performance impact of adding indexes to the Airbnb database tables.

## High-Usage Columns Identified

### Users Table
- `email`: Used in WHERE clauses for authentication and user lookup
- `created_at`: Used in WHERE clauses for filtering by registration date
- `first_name, last_name`: Used in WHERE clauses and ORDER BY for user searches

### Properties Table
- `city`: Used in WHERE clauses for location-based searches
- `country`: Used in WHERE clauses for country-specific filtering
- `host_id`: Used in JOIN operations with users table
- `price`: Used in WHERE clauses for price range filtering
- `created_at`: Used in WHERE clauses for new property listings

### Bookings Table
- `user_id`: Used in JOIN operations with users table
- `property_id`: Used in JOIN operations with properties table
- `check_in_date`: Used in WHERE clauses for date range queries
- `check_out_date`: Used in WHERE clauses for availability checking
- `status`: Used in WHERE clauses to filter by booking status

## Performance Measurements

### Test Query 1: User Authentication
**Query**: 
```sql
SELECT * FROM users WHERE email = 'user@example.com';
