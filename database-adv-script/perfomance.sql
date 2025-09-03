-- Initial complex query
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

-- Analyze the query performance
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

-- Optimized query with indexing and reduced joins
-- First, ensure proper indexes exist
CREATE INDEX IF NOT EXISTS idx_bookings_user_id ON bookings(user_id);
CREATE INDEX IF NOT EXISTS idx_bookings_property_id ON bookings(property_id);
CREATE INDEX IF NOT EXISTS idx_payments_booking_id ON payments(booking_id);
CREATE INDEX IF NOT EXISTS idx_bookings_booking_id ON bookings(booking_id);
CREATE INDEX IF NOT EXISTS idx_users_user_id ON users(user_id);
CREATE INDEX IF NOT EXISTS idx_properties_property_id ON properties(property_id);

-- Optimized query
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
    b.created_at >= CURRENT_DATE - INTERVAL '1 year' -- Limit to recent data if appropriate
ORDER BY 
    b.booking_id DESC
LIMIT 1000; -- Add reasonable limit for large datasets

-- Materialized view approach for frequently accessed complex queries
CREATE MATERIALIZED VIEW IF NOT EXISTS booking_details_mv AS
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
    payments pay ON b.booking_id = pay.booking_id;

CREATE INDEX IF NOT EXISTS idx_booking_details_mv_booking_id ON booking_details_mv(booking_id);
CREATE INDEX IF NOT EXISTS idx_booking_details_mv_user_id ON booking_details_mv(user_id);

-- Query from materialized view
SELECT * FROM booking_details_mv ORDER BY booking_id DESC;

-- Paginated query
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
    b.booking_id DESC
LIMIT 50 OFFSET 0; -- Adjust for pagination


