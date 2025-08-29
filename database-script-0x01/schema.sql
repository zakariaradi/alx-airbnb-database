-- ============================================
-- Airbnb Database Schema (3NF)
-- ============================================

-- =======================
-- Table: Users
-- =======================
CREATE TABLE Users (
    UserID SERIAL PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    PhoneNumber VARCHAR(20),
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Index on Email for fast lookup
CREATE INDEX idx_users_email ON Users(Email);

-- =======================
-- Table: Properties
-- =======================
CREATE TABLE Properties (
    PropertyID SERIAL PRIMARY KEY,
    OwnerID INT NOT NULL REFERENCES Users(UserID),
    PropertyName VARCHAR(100) NOT NULL,
    PropertyType VARCHAR(50),
    PropertyLocation VARCHAR(100),
    PricePerNight DECIMAL(10,2) NOT NULL,
    MaxGuests INT DEFAULT 1,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Index on PropertyLocation for location-based searches
CREATE INDEX idx_properties_location ON Properties(PropertyLocation);

-- =======================
-- Table: Bookings
-- =======================
CREATE TABLE Bookings (
    BookingID SERIAL PRIMARY KEY,
    UserID INT NOT NULL REFERENCES Users(UserID),
    PropertyID INT NOT NULL REFERENCES Properties(PropertyID),
    CheckIn DATE NOT NULL,
    CheckOut DATE NOT NULL,
    TotalPrice DECIMAL(10,2) GENERATED ALWAYS AS ((CheckOut - CheckIn) * (SELECT PricePerNight FROM Properties WHERE PropertyID = Bookings.PropertyID)) STORED,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_dates CHECK (CheckOut > CheckIn)
);

-- Index on UserID for fast lookup of user bookings
CREATE INDEX idx_bookings_userid ON Bookings(UserID);

-- Index on PropertyID for fast lookup of property bookings
CREATE INDEX idx_bookings_propertyid ON Bookings(PropertyID);

-- =======================
-- Table: Reviews
-- =======================
CREATE TABLE Reviews (
    ReviewID SERIAL PRIMARY KEY,
    BookingID INT NOT NULL REFERENCES Bookings(BookingID),
    Rating INT NOT NULL CHECK (Rating BETWEEN 1 AND 5),
    Comment TEXT,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Index on BookingID for faster review queries
CREATE INDEX idx_reviews_bookingid ON Reviews(BookingID);

-- =======================
-- Table: Amenities
-- =======================
CREATE TABLE Amenities (
    AmenityID SERIAL PRIMARY KEY,
    AmenityName VARCHAR(50) NOT NULL UNIQUE
);

-- =======================
-- Table: PropertyAmenities (Many-to-Many)
-- =======================
CREATE TABLE PropertyAmenities (
    PropertyID INT NOT NULL REFERENCES Properties(PropertyID),
    AmenityID INT NOT NULL REFERENCES Amenities(AmenityID),
    PRIMARY KEY(PropertyID, AmenityID)
);

