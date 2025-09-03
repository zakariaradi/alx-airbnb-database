-- Query 1: INNER JOIN to retrieve all bookings and the respective users
SELECT 
    b.booking_id,
    b.property_id,
    b.check_in_date,
    b.check_out_date,
    b.total_price,
    u.user_id,
    u.first_name,
    u.last_name,
    u.email
FROM 
    bookings b
INNER JOIN 
    users u ON b.user_id = u.user_id
ORDER BY 
    b.check_in_date DESC;


-- Query 2: LEFT JOIN to retrieve all properties and their reviews
SELECT 
    p.property_id,
    p.title AS property_title,
    p.property_type,
    p.city,
    p.country,
    r.review_id,
    r.rating,
    r.comment,
    r.review_date
FROM 
    properties p
LEFT JOIN 
    reviews r ON p.property_id = r.property_id
ORDER BY 
    p.property_id, r.review_date DESC;


-- Query 3: FULL OUTER JOIN to retrieve all users and all bookings
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.created_at AS user_created,
    b.booking_id,
    b.property_id,
    b.check_in_date,
    b.check_out_date,
    b.status AS booking_status
FROM 
    users u
FULL OUTER JOIN 
    bookings b ON u.user_id = b.user_id
ORDER BY 
    u.user_id, b.check_in_date DESC;
