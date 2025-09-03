-- Query 1: Count of bookings per user using COUNT and GROUP BY
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    COUNT(b.booking_id) AS total_bookings
FROM 
    users u
LEFT JOIN 
    bookings b ON u.user_id = b.user_id
GROUP BY 
    u.user_id, u.first_name, u.last_name, u.email
ORDER BY 
    total_bookings DESC;


-- Query 2: Rank properties by number of bookings using RANK()
SELECT 
    p.property_id,
    p.title AS property_title,
    p.property_type,
    p.city,
    p.country,
    COUNT(b.booking_id) AS total_bookings,
    RANK() OVER (ORDER BY COUNT(b.booking_id) DESC) AS booking_rank
FROM 
    properties p
LEFT JOIN 
    bookings b ON p.property_id = b.property_id
GROUP BY 
    p.property_id, p.title, p.property_type, p.city, p.country
ORDER BY 
    total_bookings DESC;


-- Query 3: Rank properties by number of bookings using ROW_NUMBER()
SELECT 
    p.property_id,
    p.title AS property_title,
    p.property_type,
    p.city,
    p.country,
    COUNT(b.booking_id) AS total_bookings,
    ROW_NUMBER() OVER (ORDER BY COUNT(b.booking_id) DESC) AS booking_row_number
FROM 
    properties p
LEFT JOIN 
    bookings b ON p.property_id = b.property_id
GROUP BY 
    p.property_id, p.title, p.property_type, p.city, p.country
ORDER BY 
    total_bookings DESC;


-- Query 4: Additional analysis - Top 3 properties in each city by bookings
WITH city_property_rankings AS (
    SELECT 
        p.property_id,
        p.title AS property_title,
        p.property_type,
        p.city,
        p.country,
        COUNT(b.booking_id) AS total_bookings,
        RANK() OVER (PARTITION BY p.city ORDER BY COUNT(b.booking_id) DESC) AS city_rank
    FROM 
        properties p
    LEFT JOIN 
        bookings b ON p.property_id = b.property_id
    GROUP BY 
        p.property_id, p.title, p.property_type, p.city, p.country
)
SELECT 
    property_id,
    property_title,
    property_type,
    city,
    country,
    total_bookings,
    city_rank
FROM 
    city_property_rankings
WHERE 
    city_rank <= 3
ORDER BY 
    city, city_rank;


-- Query 5: Additional analysis - Cumulative bookings per month
SELECT 
    DATE_TRUNC('month', booking_date) AS booking_month,
    COUNT(booking_id) AS monthly_bookings,
    SUM(COUNT(booking_id)) OVER (ORDER BY DATE_TRUNC('month', booking_date)) AS cumulative_bookings
FROM 
    bookings
GROUP BY 
    DATE_TRUNC('month', booking_date)
ORDER BY 
    booking_month;
