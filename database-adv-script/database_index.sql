-- Indexes for Users table
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_created_at ON users(created_at);
CREATE INDEX idx_users_first_last_name ON users(first_name, last_name);

-- Indexes for Properties table
CREATE INDEX idx_properties_city ON properties(city);
CREATE INDEX idx_properties_country ON properties(country);
CREATE INDEX idx_properties_host_id ON properties(host_id);
CREATE INDEX idx_properties_price ON properties(price);
CREATE INDEX idx_properties_created_at ON properties(created_at);
CREATE INDEX idx_properties_city_country ON properties(city, country);

-- Indexes for Bookings table
CREATE INDEX idx_bookings_user_id ON bookings(user_id);
CREATE INDEX idx_bookings_property_id ON bookings(property_id);
CREATE INDEX idx_bookings_check_in_date ON bookings(check_in_date);
CREATE INDEX idx_bookings_check_out_date ON bookings(check_out_date);
CREATE INDEX idx_bookings_status ON bookings(status);
CREATE INDEX idx_bookings_user_property ON bookings(user_id, property_id);
CREATE INDEX idx_bookings_dates_range ON bookings(check_in_date, check_out_date);

-- Indexes for Reviews table
CREATE INDEX idx_reviews_property_id ON reviews(property_id);
CREATE INDEX idx_reviews_user_id ON reviews(user_id);
CREATE INDEX idx_reviews_rating ON reviews(rating);
CREATE INDEX idx_reviews_created_at ON reviews(created_at);

-- Composite indexes for frequently joined columns
CREATE INDEX idx_properties_city_price ON properties(city, price);
CREATE INDEX idx_bookings_user_status ON bookings(user_id, status);
CREATE INDEX idx_bookings_property_dates ON bookings(property_id, check_in_date, check_out_date);

---------
-Test Query 2: Property Search by Location
-- Before indexing
EXPLAIN ANALYZE
SELECT * FROM properties 
WHERE city = 'San Francisco' AND country = 'USA';

-- After creating index on properties(city, country)
EXPLAIN ANALYZE
SELECT * FROM properties 
WHERE city = 'San Francisco' AND country = 'USA';

-Test Query 3: Date Range Bookings Query
-- Before indexing
EXPLAIN ANALYZE
SELECT * FROM bookings 
WHERE check_in_date BETWEEN '2023-01-01' AND '2023-12-31'
AND status = 'confirmed';

-- After creating index on bookings(check_in_date, status)
EXPLAIN ANALYZE
SELECT * FROM bookings 
WHERE check_in_date BETWEEN '2023-01-01' AND '2023-12-31'
AND status = 'confirmed';

-Test Query 4: Join Query with Filtering
-- Before indexing
EXPLAIN ANALYZE
SELECT u.first_name, u.last_name, p.title, b.check_in_date, b.check_out_date
FROM bookings b
JOIN users u ON b.user_id = u.user_id
JOIN properties p ON b.property_id = p.property_id
WHERE u.country = 'USA' AND b.status = 'completed'
ORDER BY b.check_in_date DESC
LIMIT 100;

-- After creating indexes on:
-- bookings(user_id, property_id, status)
-- users(user_id, country)
-- properties(property_id)
EXPLAIN ANALYZE
SELECT u.first_name, u.last_name, p.title, b.check_in_date, b.check_out_date
FROM bookings b
JOIN users u ON b.user_id = u.user_id
JOIN properties p ON b.property_id = p.property_id
WHERE u.country = 'USA' AND b.status = 'completed'
ORDER BY b.check_in_date DESC
LIMIT 100;

