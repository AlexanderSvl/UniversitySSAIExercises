
USE bnb;
-- Task 1 --
CREATE VIEW no_descriptions AS
	SELECT id, property_type, host_name, accommodates, bedrooms FROM listings;
    
SELECT * FROM no_descriptions;

-- Task 2 -- 
CREATE VIEW one_bedrooms AS
	SELECT id, property_type, host_name, accommodates FROM listings WHERE bedrooms = 1;
    
SELECT * FROM one_bedrooms;

-- Task 3 --
CREATE OR REPLACE VIEW available AS
	SELECT listings.id, property_type, host_name, availabilities.date FROM availabilities
    JOIN listings ON availabilities.listing_id = listings.id
    WHERE availabilities.available = 1;

SELECT * FROM available;

-- Task 4 --
CREATE VIEW frequently_reviewed AS
	SELECT listings.id, property_type, host_name, reviews.listing_id, COUNT(reviews.listing_id) AS reviewCount FROM reviews
	JOIN listings ON reviews.listing_id = listings.id
    GROUP BY reviews.listing_id;

SELECT * FROM frequently_reviewed;

-- Task 5 --
CREATE VIEW june_vacancies AS
	SELECT listings.id, listings.property_type, listings.host_name, COUNT(availabilities.date) AS days_vacant FROM listings
	JOIN availabilities ON listings.id = availabilities.listing_id
	WHERE  availabilities.date BETWEEN '2023-06-01' AND '2023-06-30' AND availabilities.available = 1  
	GROUP BY listings.id, listings.property_type, listings.host_name;
    
SELECT * FROM june_vacancies;

-- Task 6 --
-- • How many listings are there in total?  
SELECT COUNT(*) FROM no_descriptions;			-- There are 3973 listings in total.
-- • How many one-bedroom listings are there? And how many can accommodate at least 4 guests?  
SELECT COUNT(*) FROM one_bedrooms;				-- There are 1228 one bedroom listings in total.
SELECT COUNT(*) FROM one_bedrooms				-- There are 222 one bedroom that can accommodate at least 4 guests.
	WHERE accommodates >= 4;
-- • How many listings have availability for December 31st, 2023 (i.e., “2023-12-31”)? How many of those are available on any type of boat?  
SELECT * FROM available 
	WHERE date = '2023-12-31';  				-- There are 2251 available
SELECT * FROM available
	WHERE date = '2023-12-31' 
	AND LOWER(property_type) LIKE '%boat%'; 	-- There are 7
-- • How many reviews does the most frequently reviewed property have? And who is the host of that property?  
SELECT * FROM frequently_reviewed 
	GROUP BY host_name 
    ORDER BY reviewCount DESC;  				-- Tiffany’s property has 860 reviews.
-- • How many listings were available in June 2023?
SELECT COUNT(*) FROM june_vacancies;			-- There are 1895 vacancies in June.