# alx-airbnb-database

## Entities and Attributes

### 1. User
- **user_id:** UUID, Primary Key, Indexed  
- **first_name:** VARCHAR, NOT NULL  
- **last_name:** VARCHAR, NOT NULL  
- **email:** VARCHAR, UNIQUE, NOT NULL  
- **password_hash:** VARCHAR, NOT NULL  
- **phone_number:** VARCHAR, NULL  
- **role:** ENUM(guest, host, admin), NOT NULL  
- **created_at:** TIMESTAMP, DEFAULT CURRENT_TIMESTAMP  

### 2. Property
- **property_id:** UUID, Primary Key, Indexed  
- **host_id:** Foreign Key → User(user_id)  
- **name:** VARCHAR, NOT NULL  
- **description:** TEXT, NOT NULL  
- **location:** VARCHAR, NOT NULL  
- **pricepernight:** DECIMAL, NOT NULL  
- **created_at:** TIMESTAMP, DEFAULT CURRENT_TIMESTAMP  
- **updated_at:** TIMESTAMP, ON UPDATE CURRENT_TIMESTAMP  

### 3. Booking
- **booking_id:** UUID, Primary Key, Indexed  
- **property_id:** Foreign Key → Property(property_id)  
- **user_id:** Foreign Key → User(user_id)  
- **start_date:** DATE, NOT NULL  
- **end_date:** DATE, NOT NULL  
- **total_price:** DECIMAL, NOT NULL  
- **status:** ENUM(pending, confirmed, canceled), NOT NULL  
- **created_at:** TIMESTAMP, DEFAULT CURRENT_TIMESTAMP  

### 4. Payment
- **payment_id:** UUID, Primary Key, Indexed  
- **booking_id:** Foreign Key → Booking(booking_id)  
- **amount:** DECIMAL, NOT NULL  
- **payment_date:** TIMESTAMP, DEFAULT CURRENT_TIMESTAMP  
- **payment_method:** ENUM(credit_card, paypal, stripe), NOT NULL  

### 5. Review
- **review_id:** UUID, Primary Key, Indexed  
- **property_id:** Foreign Key → Property(property_id)  
- **user_id:** Foreign Key → User(user_id)  
- **rating:** INTEGER, CHECK 1-5, NOT NULL  
- **comment:** TEXT, NOT NULL  
- **created_at:** TIMESTAMP, DEFAULT CURRENT_TIMESTAMP  

### 6. Message
- **message_id:** UUID, Primary Key, Indexed  
- **sender_id:** Foreign Key → User(user_id)  
- **recipient_id:** Foreign Key → User(user_id)  
- **message_body:** TEXT, NOT NULL  
- **sent_at:** TIMESTAMP, DEFAULT CURRENT_TIMESTAMP  

---

## Relationships

| From       | To         | Cardinality | Description |
|------------|------------|------------|-------------|
| User       | Property   | 1:M        | A host can list many properties |
| User       | Booking    | 1:M        | A guest can make many bookings |
| Property   | Booking    | 1:M        | A property can be booked multiple times |
| Booking    | Payment    | 1:1 (or 1:M) | A booking has at least one payment |
| User       | Review     | 1:M        | A user can write multiple reviews |
| Property   | Review     | 1:M        | A property can have multiple reviews |
| User       | Message    | M:N        | Users can send/receive messages |

---
