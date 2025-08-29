-- ============================================
-- Airbnb Database Seed Script
-- ============================================

-- =======================
-- Users
-- =======================
INSERT INTO Users (FirstName, LastName, Email, PhoneNumber)
VALUES
('Alice', 'Johnson', 'alice.johnson@example.com', '+212600111222'),
('Bob', 'Smith', 'bob.smith@example.com', '+212600333444'),
('Charlie', 'Brown', 'charlie.brown@example.com', '+212600555666');

-- =======================
-- Properties
-- =======================
INSERT INTO Properties (OwnerID, PropertyName, PropertyType, PropertyLocation, PricePerNight, MaxGuests)
VALUES
(1, 'Cozy Cottage', 'Cottage', 'Aït Bouguemez', 100.00, 4),
(2, 'Sea View Apartment', 'Apartment', 'Agadir', 150.00, 3),
(3, 'Mountain Cabin', 'Cabin', 'Atlas Mountains', 120.00, 5);

-- =======================
-- Bookings
-- =======================
INSERT INTO Bookings (UserID, PropertyID, CheckIn, CheckOut)
VALUES
(2, 1, '2025-09-01', '2025-09-05'),
(1, 2, '2025-09-10', '2025-09-12'),
(3, 3, '2025-09-15', '2025-09-20');

-- =======================
-- Reviews
-- =======================
INSERT INTO Reviews (BookingID, Rating, Comment)
VALUES
(1, 5, 'Amazing stay! Cozy and comfortable.'),
(2, 4, 'Great location, very clean.'),
(3, 5, 'Beautiful cabin in the mountains.');

-- =======================
-- Amenities
-- =======================
INSERT INTO Amenities (AmenityName)
VALUES
('Wi-Fi'),
('Air Conditioning'),
('Kitchen'),
('Parking'),
('Pool');

-- =======================
-- PropertyAmenities
-- =======================
INSERT INTO PropertyAmenities (PropertyID, AmenityID)
VALUES
(1, 1), -- Cozy Cottage: Wi-Fi
(1, 3), -- Cozy Cottage: Kitchen
(2, 1), -- Sea View Apartment: Wi-Fi
(2, 2), -- Sea View Apartment: Air Conditioning
(2, 5), -- Sea View Apartment: Pool
(3, 1), -- Mountain Cabin: Wi-Fi
(3, 3), -- Mountain Cabin: Kitchen
(3, 4); -- Mountain Cabin: Parking

