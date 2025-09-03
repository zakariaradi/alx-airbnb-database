-- partitioning.sql
-- Implement table partitioning for the bookings table based on check_in_date

-- Step 1: Create the partitioned table structure
CREATE TABLE bookings_partitioned (
    booking_id SERIAL,
    user_id INTEGER NOT NULL,
    property_id INTEGER NOT NULL,
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (booking_id, check_in_date)
) PARTITION BY RANGE (check_in_date);

-- Step 2: Create partitions for different date ranges
-- Partition for historical data (before 2023)
CREATE TABLE bookings_historical PARTITION OF bookings_partitioned
    FOR VALUES FROM ('2000-01-01') TO ('2023-01-01');

-- Partition for 2023 data
CREATE TABLE bookings_2023 PARTITION OF bookings_partitioned
    FOR VALUES FROM ('2023-01-01') TO ('2024-01-01');

-- Partition for 2024 data
CREATE TABLE bookings_2024 PARTITION OF bookings_partitioned
    FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');

-- Partition for 2025 data
CREATE TABLE bookings_2025 PARTITION OF bookings_partitioned
    FOR VALUES FROM ('2025-01-01') TO ('2026-01-01');

-- Partition for future bookings (2026 and beyond)
CREATE TABLE bookings_future PARTITION OF bookings_partitioned
    FOR VALUES FROM ('2026-01-01') TO ('2100-01-01');

-- Step 3: Create indexes on the partitioned table
CREATE INDEX idx_bookings_partitioned_check_in ON bookings_partitioned(check_in_date);
CREATE INDEX idx_bookings_partitioned_user_id ON bookings_partitioned(user_id);
CREATE INDEX idx_bookings_partitioned_property_id ON bookings_partitioned(property_id);
CREATE INDEX idx_bookings_partitioned_status ON bookings_partitioned(status);

-- Step 4: Migrate data from original bookings table to partitioned table
INSERT INTO bookings_partitioned 
SELECT * FROM bookings;

-- Step 5: Verify data migration
SELECT 'Total records in original table' as description, COUNT(*) as count FROM bookings
UNION ALL
SELECT 'Total records in partitioned table', COUNT(*) FROM bookings_partitioned;

-- Step 6: Check partition distribution
SELECT 
    'bookings_historical' as partition_name, 
    COUNT(*) as record_count 
FROM bookings_historical
UNION ALL
SELECT 'bookings_2023', COUNT(*) FROM bookings_2023
UNION ALL
SELECT 'bookings_2024', COUNT(*) FROM bookings_2024
UNION ALL
SELECT 'bookings_2025', COUNT(*) FROM bookings_2025
UNION ALL
SELECT 'bookings_future', COUNT(*) FROM bookings_future;

-- Step 7: Create a view for backward compatibility (optional)
CREATE OR REPLACE VIEW bookings AS
SELECT * FROM bookings_partitioned;

-- Step 8: Performance testing queries
-- Query 1: Fetch bookings for a specific date range (will use partition pruning)
EXPLAIN ANALYZE
SELECT * FROM bookings_partitioned 
WHERE check_in_date BETWEEN '2024-03-01' AND '2024-03-31';

-- Query 2: Fetch bookings for a different date range
EXPLAIN ANALYZE
SELECT * FROM bookings_partitioned 
WHERE check_in_date BETWEEN '2023-07-01' AND '2023-07-31';

-- Query 3: Compare with original table (if still exists)
EXPLAIN ANALYZE
SELECT * FROM bookings 
WHERE check_in_date BETWEEN '2024-03-01' AND '2024-03-31';

-- Query 4: Complex query with joins on partitioned table
EXPLAIN ANALYZE
SELECT 
    bp.booking_id,
    bp.check_in_date,
    bp.check_out_date,
    bp.total_price,
    bp.status,
    u.first_name,
    u.last_name,
    p.title as property_title
FROM 
    bookings_partitioned bp
JOIN 
    users u ON bp.user_id = u.user_id
JOIN 
    properties p ON bp.property_id = p.property_id
WHERE 
    bp.check_in_date BETWEEN '2024-01-01' AND '2024-12-31'
    AND bp.status = 'confirmed';

-- Query 5: Aggregation query on partitioned data
EXPLAIN ANALYZE
SELECT 
    DATE_TRUNC('month', check_in_date) as month,
    COUNT(*) as booking_count,
    SUM(total_price) as total_revenue
FROM 
    bookings_partitioned
WHERE 
    check_in_date BETWEEN '2023-01-01' AND '2024-12-31'
GROUP BY 
    DATE_TRUNC('month', check_in_date)
ORDER BY 
    month;

-- Step 9: Create function to automatically manage partitions
CREATE OR REPLACE FUNCTION create_booking_partition(year INTEGER)
RETURNS void AS $$
BEGIN
    EXECUTE format(
        'CREATE TABLE IF NOT EXISTS bookings_%s PARTITION OF bookings_partitioned
        FOR VALUES FROM (%L) TO (%L)',
        year,
        format('%s-01-01', year),
        format('%s-01-01', year + 1)
    );
END;
$$ LANGUAGE plpgsql;

-- Step 10: Create default partition for any unexpected data
CREATE TABLE bookings_default PARTITION OF bookings_partitioned DEFAULT;

-- Step 11: Verify partition constraint exclusion is working
EXPLAIN ANALYZE
SELECT * FROM bookings_partitioned 
WHERE check_in_date < '2023-01-01';
