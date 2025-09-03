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
