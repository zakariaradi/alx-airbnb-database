### Entity Details

**User**
- PK: user_id  
- Attributes: first_name, last_name, email, password_hash, phone_number, role, created_at  

**Property**
- PK: property_id  
- FK: host_id → User(user_id)  
- Attributes: name, description, location, pricepernight, created_at, updated_at  

**Booking**
- PK: booking_id  
- FKs: property_id → Property(property_id), user_id → User(user_id)  
- Attributes: start_date, end_date, total_price, status, created_at  

**Payment**
- PK: payment_id  
- FK: booking_id → Booking(booking_id)  
- Attributes: amount, payment_date, payment_method  

**Review**
- PK: review_id  
- FKs: property_id → Property(property_id), user_id → User(user_id)  
- Attributes: rating, comment, created_at  

**Message**
- PK: message_id  
- FKs: sender_id → User(user_id), recipient_id → User(user_id)  
- Attributes: message_body, sent_at  

### Relationships

| From       | To         | Cardinality | Description |
|------------|------------|------------|-------------|
| User       | Property   | 1:M        | Host lists multiple properties |
| User       | Booking    | 1:M        | Guest makes multiple bookings |
| Property   | Booking    | 1:M        | Property can be booked multiple times |
| Booking    | Payment    | 1:1 (or 1:M) | Booking has at least one payment |
| User       | Review     | 1:M        | User writes multiple reviews |
| Property   | Review     | 1:M        | Property can have multiple reviews |
| User       | Message    | M:N        | Users send and receive messages |
