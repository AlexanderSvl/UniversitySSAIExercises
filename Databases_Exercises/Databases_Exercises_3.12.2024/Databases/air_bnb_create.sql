-- Create the database
CREATE DATABASE IF NOT EXISTS bnb;
USE bnb;

-- Table: listings (must be created first because availabilities references it)
CREATE TABLE IF NOT EXISTS `listings` (
    `id` BIGINT NOT NULL AUTO_INCREMENT, -- Added AUTO_INCREMENT for primary key
    `property_type` VARCHAR(255), -- Changed TEXT to VARCHAR
    `host_name` VARCHAR(255), -- Changed TEXT to VARCHAR
    `accommodates` INT,
    `bedrooms` INT,
    `description` TEXT, -- Kept TEXT as descriptions can be long
    PRIMARY KEY(`id`)
);
-- Table: availabilities
CREATE TABLE IF NOT EXISTS `availabilities` (
    `id` BIGINT NOT NULL AUTO_INCREMENT, -- Added AUTO_INCREMENT for primary key
    `listing_id` BIGINT,
    `date` DATE, -- Changed NUMERIC to DATE
    `available` TINYINT(1), -- Changed INTEGER to TINYINT for boolean representation
    `price` DECIMAL(10, 2), -- Changed NUMERIC to DECIMAL with precision
    PRIMARY KEY(`id`),
    FOREIGN KEY(`listing_id`) REFERENCES `listings`(`id`)
);

-- Table: reviews
CREATE TABLE IF NOT EXISTS `reviews` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `listing_id` BIGINT,
    `date` DATE,
    `reviewer_name` TEXT,
    `comments` TEXT,
    PRIMARY KEY(`id`),
    FOREIGN KEY(`listing_id`) REFERENCES `listings`(`id`)
);

-- IMPORT DATA FROM CSV
SET GLOBAL local_infile=1;

LOAD DATA LOCAL INFILE  'C:/Users/User/Desktop/University/UniversityExercises/Databases_Exercises/Databases_Exercises_3.12.2024/Databases/CSVs/LabExercise_06_listings.csv'
INTO TABLE listings
FIELDS TERMINATED BY ';' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE  'C:/Users/User/Desktop/University/UniversityExercises/Databases_Exercises/Databases_Exercises_3.12.2024/Databases/CSVs/LabExercise_06_reviews.csv'
INTO TABLE reviews
FIELDS TERMINATED BY ';' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE  'C:/Users/User/Desktop/University/UniversityExercises/Databases_Exercises/Databases_Exercises_3.12.2024/Databases/CSVs/LabExercise_06_availabilities.csv'
INTO TABLE availabilities
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;