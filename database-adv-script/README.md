# Complex SQL Queries with Joins

This repository contains SQL queries demonstrating different types of joins for the ALX Airbnb Database project.

## Queries Overview

### 1. INNER JOIN: Bookings with Users
This query retrieves all bookings along with the user information of the person who made each booking. It uses an INNER JOIN to only return records where there's a match between the bookings and users tables.

**Purpose**: To analyze booking patterns with user details for better customer relationship management.

### 2. LEFT JOIN: Properties with Reviews
This query retrieves all properties along with their reviews, including properties that have no reviews. It uses a LEFT JOIN to ensure all properties are returned regardless of whether they have reviews or not.

**Purpose**: To assess property performance and identify properties that may need more attention based on review presence or absence.

### 3. FULL OUTER JOIN: Users with Bookings
This query retrieves all users and all bookings, ensuring that users without bookings and bookings not linked to users are both included. It uses a FULL OUTER JOIN to capture all records from both tables.

**Purpose**: To perform comprehensive data analysis that identifies both inactive users and orphaned bookings for data integrity checks.

## Database Schema

The queries assume the following table structure:

### Users Table
- user_id (Primary Key)
- first_name
- last_name
- email
- created_at

### Properties Table
- property_id (Primary Key)
- title
- property_type
- city
- country

### Bookings Table
- booking_id (Primary Key)
- property_id (Foreign Key)
- user_id (Foreign Key)
- check_in_date
- check_out_date
- total_price
- status

### Reviews Table
- review_id (Primary Key)
- property_id (Foreign Key)
- user_id (Foreign Key)
- rating
- comment
- review_date

## Usage

1. Ensure you have access to the Airbnb database with the appropriate tables
2. Execute the queries in your SQL client or application
3. Modify the queries as needed for your specific use case

## Learning Objectives

By working with these queries, you will:
- Understand the differences between INNER JOIN, LEFT JOIN, and FULL OUTER JOIN
- Learn how to retrieve related data from multiple tables
- Gain experience in writing complex SQL queries for real-world scenarios
- Develop skills in data analysis using relational database joins

## Notes

- The FULL OUTER JOIN might not be supported in all database systems (like MySQL). In such cases, you can emulate it using a UNION of LEFT and RIGHT JOINs.
- Always consider adding appropriate indexes on foreign key columns to improve join performance.
- These queries can be extended with WHERE clauses, additional joins, or aggregations based on specific requirements.

--------------------------------------------------------------------------------------------------------------------------------------------
 

# SQL Aggregations and Window Functions

This repository contains SQL queries demonstrating aggregation functions and window functions for the ALX Airbnb Database project.

## Queries Overview

### 1. Bookings Count per User
This query calculates the total number of bookings made by each user using the COUNT aggregation function and GROUP BY clause.

**Purpose**: To identify the most active users and understand user booking patterns.

### 2. Property Ranking by Bookings using RANK()
This query ranks properties based on the total number of bookings they have received using the RANK() window function.

**Purpose**: To identify the most popular properties and understand property performance.

### 3. Property Ranking by Bookings using ROW_NUMBER()
This query ranks properties based on the total number of bookings they have received using the ROW_NUMBER() window function.

**Purpose**: To demonstrate the difference between RANK() and ROW_NUMBER() functions.

### 4. Top 3 Properties in Each City
This query uses a Common Table Expression (CTE) and the RANK() window function with PARTITION BY to find the top 3 properties in each city based on bookings.

**Purpose**: To analyze property performance at the city level and identify local market leaders.

### 5. Cumulative Bookings Over Time
This query calculates monthly bookings and cumulative bookings over time using the SUM() window function.

**Purpose**: To track booking trends and growth patterns over time.

## Database Schema

The queries assume the following table structure:

### Users Table
- user_id (Primary Key)
- first_name
- last_name
- email
- created_at

### Properties Table
- property_id (Primary Key)
- title
- property_type
- city
- country

### Bookings Table
- booking_id (Primary Key)
- property_id (Foreign Key)
- user_id (Foreign Key)
- booking_date
- check_in_date
- check_out_date
- total_price
- status

## Key Concepts

### Aggregation Functions
- **COUNT()**: Returns the number of rows that match a specified condition
- **SUM()**: Returns the sum of values in a set
- **GROUP BY**: Groups rows that have the same values into summary rows

### Window Functions
- **RANK()**: Assigns a rank to each row within a partition, with gaps in ranking values
- **ROW_NUMBER()**: Assigns a unique sequential integer to each row within a partition
- **OVER()**: Defines the window or set of rows that the window function operates on
- **PARTITION BY**: Divides the result set into partitions to which the window function is applied

## Usage

1. Ensure you have access to the Airbnb database with the appropriate tables
2. Execute the queries in your SQL client or application
3. Modify the queries as needed for your specific use case

## Learning Objectives

By working with these queries, you will:
- Understand how to use aggregation functions with GROUP BY
- Learn the differences between various window functions (RANK vs ROW_NUMBER)
- Gain experience in writing complex analytical queries
- Develop skills in data analysis using SQL window functions
- Understand how to use PARTITION BY to create rankings within groups

## Notes

- Window functions are evaluated after aggregation, so they can operate on aggregated values
- RANK() will assign the same rank to rows with equal values, skipping subsequent ranks
- ROW_NUMBER() will always assign unique numbers, even to rows with equal values
- These queries can be extended with additional filters, ordering, or partitioning based on specific requirements
