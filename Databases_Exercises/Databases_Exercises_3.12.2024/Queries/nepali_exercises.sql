USE nepali;
SELECT * FROM census;

-- Task 1 --
CREATE VIEW rural AS
	SELECT * FROM census 
		WHERE LOWER(locality) LIKE '%rural%';
        
SELECT * FROM rural;

-- Task 2 --
CREATE VIEW total AS
	SELECT SUM(families) AS totalFamilies, SUM(households) AS totalHouseholds, 
		   SUM(population) AS totalPopulation, SUM(male) AS totalMales, 
           SUM(female) AS totalFemales FROM census;
            
SELECT * FROM total;

-- Task 3 --
CREATE VIEW by_district AS
	SELECT district, SUM(families) AS totalFamilies, SUM(households) AS totalHouseholds, 
		   SUM(population) AS totalPopulation, SUM(male) AS totalMales, 
           SUM(female) AS totalFemales FROM census
    GROUP BY district;

SELECT * FROM by_district;

-- Task 4 --
CREATE OR REPLACE VIEW most_populated AS
	SELECT district, SUM(families) AS totalFamilies, SUM(households) AS totalHouseholds, 
		   SUM(population) AS totalPopulation, SUM(male) AS totalMales, 
           SUM(female) AS totalFemales FROM census
    GROUP BY district
    ORDER BY totalPopulation DESC;

SELECT * FROM most_populated;

-- Task 5 --
-- • How many rural districts are there? How many families live in rural districts? 
SELECT COUNT(*) FROM rural;		 			-- There are 461 rural districts in Nepal.
SELECT SUM(families) FROM rural; 			-- There are 2 229 834 nepali families that are living in rural districts.

-- • How many households are in Nepal?
SELECT totalHouseholds FROM total;  		-- There are 5 642 674 households in Nepal.

-- • Which district has the second lowest number of families? And how many does it have?  
SELECT district, totalFamilies FROM by_district 
	ORDER BY totalFamilies ASC LIMIT 2; 	-- The second lowest number of families is 3751 and it is in Mustang (nice)

-- • Which district has the highest population? And how many households are in that district? 
SELECT district, totalHouseholds, totalPopulation 
	FROM most_populated LIMIT 1;	 		-- The highest populated districts is Kathmandu with 275 806 households.