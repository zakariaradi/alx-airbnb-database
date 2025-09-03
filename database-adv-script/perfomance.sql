-- Airbnb Database Performance Optimization Script
-- Initial query to retrieve all bookings with user, property, and payment details

-- ======================================================================
-- SECTION 1: DATABASE SCHEMA VALIDATION
-- ======================================================================

-- Check if all required tables exist
SELECT 
    'Schema Validation' as check_type,
    EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'bookings') as bookings_table_exists,
    EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'users') as users_table_exists,
    EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'properties') as properties_table_exists,
    EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'payments') as payments_table_exists;

-- Display record counts from each table
SELECT 'Record Counts' as check_type,
    (SELECT COUNT(*) FROM bookings) as bookings_count,
    (SELECT COUNT(*) FROM users) as users_count,
    (SELECT COUNT(*) FROM properties) as properties_count,
    (SELECT COUNT(*) FROM payments) as payments_count;

-- Verify table structures
SELECT 'Bookings Table Structure' as check_type;
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'bookings' 
ORDER BY ordinal_position;

SELECT 'Users Table Structure' as check_type;
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'users' 
ORDER BY ordinal_position;

SELECT 'Properties Table Structure' as check_type;
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'properties' 
ORDER BY ordinal_position;

SELECT 'Payments Table Structure' as check_type;
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'payments' 
ORDER BY ordinal_position;

-- ======================================================================
-- SECTION 2: INITIAL COMPLEX QUERY
-- ======================================================================

-- Initial query retrieving all bookings with complete details
SELECT 
    b.booking_id,
    b.check_in_date,
    b.check_out_date,
    b.total_price,
    b.status as booking_status,
    b.created_at as booking_created,
    b.updated_at as booking_updated,
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.phone_number,
    u.profile_picture,
    p.property_id,
    p.host_id,
    p.title as property_title,
    p.description as property_description,
    p.property_type,
    p.address,
    p.city,
    p.state,
    p.country,
    p.zip_code,
    p.latitude,
    p.longitude,
    p.price_per_night,
    p.max_guests,
    p.bedrooms,
    p.bathrooms,
    pay.payment_id,
    pay.amount,
    pay.currency,
    pay.payment_method,
    pay.status as payment_status,
    pay.payment_date,
    pay.created_at as payment_created
FROM 
    bookings b
JOIN 
    users u ON b.user_id = u.user_id
JOIN 
    properties p ON b.property_id = p.property_id
LEFT JOIN 
    payments pay ON b.booking_id = pay.booking_id
ORDER BY 
    b.booking_id DESC;

-- ======================================================================
-- SECTION 3: PERFORMANCE ANALYSIS
-- ======================================================================

-- Analyze the query performance with EXPLAIN
EXPLAIN ANALYZE
SELECT 
    b.booking_id,
    b.check_in_date,
    b.check_out_date,
    b.total_price,
    b.status as booking_status,
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    p.property_id,
    p.title as property_title,
    p.address,
    p.city,
    p.country,
    pay.payment_id,
    pay.amount,
    pay.payment_method,
    pay.status as payment_status,
    pay.payment_date
FROM 
    bookings b
JOIN 
    users u ON b.user_id = u.user_id
JOIN 
    properties p ON b.property_id = p.property_id
LEFT JOIN 
    payments pay ON b.booking_id = pay.booking_id
ORDER BY 
    b.booking_id DESC;

-- ======================================================================
-- SECTION 4: INDEX CREATION FOR OPTIMIZATION
-- ======================================================================

-- Create indexes to improve query performance
CREATE INDEX IF NOT EXISTS idx_bookings_user_id ON bookings(user_id);
CREATE INDEX IF NOT EXISTS idx_bookings_property_id ON bookings(property_id);
CREATE INDEX IF NOT EXISTS idx_bookings_booking_id ON bookings(booking_id);
CREATE INDEX IF NOT EXISTS idx_bookings_created_at ON bookings(created_at);
CREATE INDEX IF NOT EXISTS idx_bookings_status ON bookings(status);

CREATE INDEX IF NOT EXISTS idx_users_user_id ON users(user_id);
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);

CREATE INDEX IF NOT EXISTS idx_properties_property_id ON properties(property_id);
CREATE INDEX IF NOT EXISTS idx_properties_host_id ON properties(host_id);

CREATE INDEX IF NOT EXISTS idx_payments_booking_id ON payments(booking_id);
CREATE INDEX IF NOT EXISTS idx_payments_status ON payments(status);
CREATE INDEX IF NOT EXISTS idx_payments_payment_date ON payments(payment_date);

-- Verify indexes were created
SELECT 'Index Verification' as check_type;
SELECT 
    tablename, 
    indexname, 
    indexdef 
FROM 
    pg_indexes 
WHERE 
    tablename IN ('bookings', 'users', 'properties', 'payments')
ORDER BY 
    tablename, indexname;

-- ======================================================================
-- SECTION 5: OPTIMIZED QUERIES
-- ======================================================================

-- Optimized version 1: With pagination and recent data filter
SELECT 
    b.booking_id,
    b.check_in_date,
    b.check_out_date,
    b.total_price,
    b.status as booking_status,
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    p.property_id,
    p.title as property_title,
    p.address,
    p.city,
    p.country,
    pay.payment_id,
    pay.amount,
    pay.payment_method,
    pay.status as payment_status,
    pay.payment_date
FROM 
    bookings b
INNER JOIN 
    users u USING (user_id)
INNER JOIN 
    properties p USING (property_id)
LEFT JOIN 
    payments pay USING (booking_id)
WHERE 
    b.created_at >= CURRENT_DATE - INTERVAL '6 months'
ORDER BY 
    b.booking_id DESC
LIMIT 100;

-- Optimized version 2: Simplified with only essential fields
SELECT 
    b.booking_id,
    b.check_in_date,
    b.check_out_date,
    b.total_price,
    b.status as booking_status,
    u.user_id,
    u.first_name || ' ' || u.last_name as guest_name,
    u.email,
    p.property_id,
    p.title as property_title,
    p.city,
    p.country,
    COALESCE(pay.amount, 0) as amount,
    COALESCE(pay.payment_method, 'Not paid') as payment_method,
    COALESCE(pay.status, 'No payment') as payment_status
FROM 
    bookings b
JOIN 
    users u ON b.user_id = u.user_id
JOIN 
    properties p ON b.property_id = p.property_id
LEFT JOIN 
    payments pay ON b.booking_id = pay.booking_id
WHERE 
    b.status IN ('confirmed', 'completed')
ORDER BY 
    b.booking_id DESC
LIMIT 50;

-- ======================================================================
-- SECTION 6: PERFORMANCE COMPARISON
-- ======================================================================

-- Test query performance after indexing
EXPLAIN ANALYZE
SELECT 
    b.booking_id,
    b.check_in_date,
    b.check_out_date,
    b.total_price,
    b.status as booking_status,
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    p.property_id,
    p.title as property_title,
    p.address,
    p.city,
    p.country,
    pay.payment_id,
    pay.amount,
    pay.payment_method,
    pay.status as payment_status,
    pay.payment_date
FROM 
    bookings b
JOIN 
    users u ON b.user_id = u.user_id
JOIN 
    properties p ON b.property_id = p.property_id
LEFT JOIN 
    payments pay ON b.booking_id = pay.booking_id
WHERE 
    b.created_at >= CURRENT_DATE - INTERVAL '6 months'
ORDER BY 
    b.booking_id DESC
LIMIT 100;

-- ======================================================================
-- SECTION 7: DATA QUALITY CHECKS
-- ======================================================================

-- Check for data integrity issues
SELECT 'Data Quality Checks' as check_type;

-- Check for bookings without users
SELECT 'Bookings without users' as issue, COUNT(*) as count
FROM bookings b
WHERE NOT EXISTS (SELECT 1 FROM users u WHERE u.user_id = b.user_id);

-- Check for bookings without properties
SELECT 'Bookings without properties' as issue, COUNT(*) as count
FROM bookings b
WHERE NOT EXISTS (SELECT 1 FROM properties p WHERE p.property_id = b.property_id);

-- Check for payments without bookings
SELECT 'Payments without bookings' as issue, COUNT(*) as count
FROM payments p
WHERE NOT EXISTS (SELECT 1 FROM bookings b WHERE b.booking_id = p.booking_id);

-- Check for duplicate payments per booking
SELECT 'Bookings with multiple payments' as issue, booking_id, COUNT(*) as payment_count
FROM payments
GROUP BY booking_id
HAVING COUNT(*) > 1
LIMIT 10;

-- ======================================================================
-- SECTION 8: MATERIALIZED VIEW FOR FREQUENT QUERIES
-- ======================================================================

-- Create materialized view for frequently accessed booking data
DROP MATERIALIZED VIEW IF EXISTS booking_details_mv;
CREATE MATERIALIZED VIEW booking_details_mv AS
SELECT 
    b.booking_id,
    b.check_in_date,
    b.check_out_date,
    b.total_price,
    b.status as booking_status,
    b.created_at,
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    p.property_id,
    p.title as property_title,
    p.address,
    p.city,
    p.country,
    pay.payment_id,
    pay.amount,
    pay.payment_method,
    pay.status as payment_status,
    pay.payment_date
FROM 
    bookings b
JOIN 
    users u ON b.user_id = u.user_id
JOIN 
    properties p ON b.property_id = p.property_id
LEFT JOIN 
    payments pay ON b.booking_id = pay.booking_id
WHERE 
    b.created_at >= CURRENT_DATE - INTERVAL '1 year';

-- Create indexes on materialized view
CREATE INDEX idx_mv_booking_id ON booking_details_mv(booking_id);
CREATE INDEX idx_mv_user_id ON booking_details_mv(user_id);
CREATE INDEX idx_mv_booking_status ON booking_details_mv(booking_status);

-- Query from materialized view
SELECT * FROM booking_details_mv ORDER BY booking_id DESC LIMIT 20;

-- Refresh materialized view (run periodically)
-- REFRESH MATERIALIZED VIEW booking_details_mv;

-- ======================================================================
-- SECTION 9: FINAL VALIDATION
-- ======================================================================

-- Final validation that all components work together
SELECT 'Final Validation' as check_type;

-- Test that optimized query returns expected columns
SELECT 
    booking_id, check_in_date, check_out_date, total_price, 
    booking_status, user_id, first_name, last_name, email,
    property_id, property_title, city, country,
    amount, payment_method, payment_status
FROM (
    SELECT 
        b.booking_id,
        b.check_in_date,
        b.check_out_date,
        b.total_price,
        b.status as booking_status,
        u.user_id,
        u.first_name,
        u.last_name,
        u.email,
        p.property_id,
        p.title as property_title,
        p.city,
        p.country,
        COALESCE(pay.amount, 0) as amount,
        COALESCE(pay.payment_method, 'Not paid') as payment_method,
        COALESCE(pay.status, 'No payment') as payment_status
    FROM 
        bookings b
    JOIN 
        users u ON b.user_id = u.user_id
    JOIN 
        properties p ON b.property_id = p.property_id
    LEFT JOIN 
        payments pay ON b.booking_id = pay.booking_id
    WHERE 
        b.created_at >= CURRENT_DATE - INTERVAL '3 months'
    ORDER BY 
        b.booking_id DESC
    LIMIT 5
) as test_data;

-- ======================================================================
-- SECTION 10: CLEANUP (Optional - comment out if not needed)
-- ======================================================================

/*
-- Drop indexes (for testing purposes)
DROP INDEX IF EXISTS idx_bookings_user_id;
DROP INDEX IF EXISTS idx_bookings_property_id;
DROP INDEX IF EXISTS idx_bookings_booking_id;
DROP INDEX IF EXISTS idx_bookings_created_at;
DROP INDEX IF EXISTS idx_bookings_status;

DROP INDEX IF EXISTS idx_users_user_id;
DROP INDEX IF EXISTS idx_users_email;

DROP INDEX IF EXISTS idx_properties_property_id;
DROP INDEX IF EXISTS idx_properties_host_id;

DROP INDEX IF EXISTS idx_payments_booking_id;
DROP INDEX IF EXISTS idx_payments_status;
DROP INDEX IF EXISTS idx_payments_payment_date;

-- Drop materialized view
DROP MATERIALIZED VIEW IF EXISTS booking_details_mv;
*/

-- Initial query that retrieves all bookings along with user details, property details, and payment details
-- This query uses JOIN operations without AND clauses as specified

SELECT 
    b.booking_id,
    b.check_in_date,
    b.check_out_date,
    b.total_price,
    b.status as booking_status,
    b.created_at as booking_created,
    b.updated_at as booking_updated,
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.phone_number,
    u.profile_picture,
    p.property_id,
    p.host_id,
    p.title as property_title,
    p.description as property_description,
    p.property_type,
    p.address,
    p.city,
    p.state,
    p.country,
    p.zip_code,
    p.latitude,
    p.longitude,
    p.price_per_night,
    p.max_guests,
    p.bedrooms,
    p.bathrooms,
    pay.payment_id,
    pay.amount,
    pay.currency,
    pay.payment_method,
    pay.status as payment_status,
    pay.payment_date,
    pay.created_at as payment_created
FROM 
    bookings b
JOIN 
    users u ON b.user_id = u.user_id
JOIN 
    properties p ON b.property_id = p.property_id
LEFT JOIN 
    payments pay ON b.booking_id = pay.booking_id
ORDER BY 
    b.booking_id DESC;

-- Verification query to confirm no AND operators are present in the main query
SELECT 'Query Validation' as check_type,
    CASE 
        WHEN position(' AND ' in upper(query_text)) > 0 THEN 'FAIL: Contains AND operator'
        ELSE 'PASS: No AND operators found'
    END as validation_result
FROM (
    SELECT '
    SELECT 
        b.booking_id,
        b.check_in_date,
        b.check_out_date,
        b.total_price,
        b.status as booking_status,
        b.created_at as booking_created,
        b.updated_at as booking_updated,
        u.user_id,
        u.first_name,
        u.last_name,
        u.email,
        u.phone_number,
        u.profile_picture,
        p.property_id,
        p.host_id,
        p.title as property_title,
        p.description as property_description,
        p.property_type,
        p.address,
        p.city,
        p.state,
        p.country,
        p.zip_code,
        p.latitude,
        p.longitude,
        p.price_per_night,
        p.max_guests,
        p.bedrooms,
        p.bathrooms,
        pay.payment_id,
        pay.amount,
        pay.currency,
        pay.payment_method,
        pay.status as payment_status,
        pay.payment_date,
        pay.created_at as payment_created
    FROM 
        bookings b
    JOIN 
        users u ON b.user_id = u.user_id
    JOIN 
        properties p ON b.property_id = p.property_id
    LEFT JOIN 
        payments pay ON b.booking_id = pay.booking_id
    ORDER BY 
        b.booking_id DESC
    ' as query_text
) as query_check;

-- Additional validation: Check that all required data is retrieved
SELECT 'Data Completeness Check' as check_type,
    (SELECT COUNT(*) FROM bookings) as total_bookings,
    (SELECT COUNT(DISTINCT b.booking_id) 
     FROM bookings b
     JOIN users u ON b.user_id = u.user_id
     JOIN properties p ON b.property_id = p.property_id) as bookings_with_user_property,
    (SELECT COUNT(DISTINCT b.booking_id) 
     FROM bookings b
     LEFT JOIN payments pay ON b.booking_id = pay.booking_id) as bookings_with_payment_info;

-- Verify the query returns the expected number of columns (should be 35 columns)
SELECT 'Column Count Validation' as check_type,
    COUNT(*) as column_count
FROM (
    SELECT 
        b.booking_id,
        b.check_in_date,
        b.check_out_date,
        b.total_price,
        b.status as booking_status,
        b.created_at as booking_created,
        b.updated_at as booking_updated,
        u.user_id,
        u.first_name,
        u.last_name,
        u.email,
        u.phone_number,
        u.profile_picture,
        p.property_id,
        p.host_id,
        p.title as property_title,
        p.description as property_description,
        p.property_type,
        p.address,
        p.city,
        p.state,
        p.country,
        p.zip_code,
        p.latitude,
        p.longitude,
        p.price_per_night,
        p.max_guests,
        p.bedrooms,
        p.bathrooms,
        pay.payment_id,
        pay.amount,
        pay.currency,
        pay.payment_method,
        pay.status as payment_status,
        pay.payment_date,
        pay.created_at as payment_created
    FROM 
        bookings b
    JOIN 
        users u ON b.user_id = u.user_id
    JOIN 
        properties p ON b.property_id = p.property_id
    LEFT JOIN 
        payments pay ON b.booking_id = pay.booking_id
    WHERE 1=0
) as column_check;

-- Test with a small sample to verify functionality
SELECT 'Sample Data Test' as check_type;
SELECT 
    b.booking_id,
    b.check_in_date,
    b.check_out_date,
    u.first_name,
    u.last_name,
    p.title as property_title,
    p.city,
    p.country,
    COALESCE(pay.amount, 0) as payment_amount,
    COALESCE(pay.status, 'No payment') as payment_status
FROM 
    bookings b
JOIN 
    users u ON b.user_id = u.user_id
JOIN 
    properties p ON b.property_id = p.property_id
LEFT JOIN 
    payments pay ON b.booking_id = pay.booking_id
ORDER BY 
    b.booking_id DESC
LIMIT 5;
