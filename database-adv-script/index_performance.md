
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

-----

# Query Performance Measurement with EXPLAIN and ANALYZE

This document provides a methodology for measuring query performance before and after index implementation using PostgreSQL's EXPLAIN and ANALYZE commands.

## Understanding EXPLAIN and ANALYZE

### EXPLAIN
The EXPLAIN command shows the execution plan that the PostgreSQL planner generates for a given SQL statement. It reveals:
- The scan method (sequential scan, index scan, etc.)
- Join algorithms
- Estimated costs and row counts
- Operation order

### EXPLAIN ANALYZE
The EXPLAIN ANALYZE command actually executes the query and provides:
- Actual execution time
- Actual row counts
- Comparison between estimates and actual values
- Buffer usage statistics

## Performance Measurement Methodology

### 1. Identify Key Queries
Identify the most frequently executed and performance-critical queries in your application.

### 2. Establish Baseline Performance
Run EXPLAIN ANALYZE on each query before creating indexes to establish a baseline.

### 3. Create Appropriate Indexes
Based on the query patterns and WHERE clause conditions, create targeted indexes.

### 4. Measure Performance Improvement
Run EXPLAIN ANALYZE again after index creation to measure improvement.

### 5. Document Results
Record the before and after performance metrics for comparison.

## Example Queries for Testing

### Test Query 1: User Authentication
```sql
-- Before indexing
EXPLAIN ANALYZE 
SELECT * FROM users WHERE email = 'user@example.com';

-- After creating index on users(email)
EXPLAIN ANALYZE 
SELECT * FROM users WHERE email = 'user@example.com';
