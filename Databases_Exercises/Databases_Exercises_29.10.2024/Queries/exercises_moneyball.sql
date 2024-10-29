USE moneyball;

SELECT * FROM performances;
SELECT * FROM salaries;
SELECT * FROM players;
SELECT * FROM teams;

-- Task 1 --
SELECT year, ROUND(AVG(salary), 2) AS 'Average Salary' 
	FROM salaries
	GROUP BY year
	ORDER BY 'Average Salary' DESC;
    
-- Task 2 --
SELECT player_id, year, salary FROM salaries
	WHERE player_id = ( 
		SELECT id FROM players 
			WHERE first_name LIKE '%Cal%' 
            AND last_name LIKE '%Ripken%'
		)
	ORDER BY year DESC;
    
-- Task 3 --
SELECT player_id, year, HR AS 'Home runs' FROM performances
	WHERE player_id = ( 
		SELECT id FROM players 
			WHERE first_name LIKE '%Ken%' 
            AND last_name LIKE '%Griffey%'
            AND birth_year = 1969
		)
	ORDER BY year DESC;
    
-- Task 4 --
SELECT first_name, last_name, salary
	FROM salaries s
	JOIN players p ON s.player_id = p.id
	WHERE s.year = 2001
	ORDER BY s.salary ASC, p.first_name ASC, p.last_name ASC, p.id	
    LIMIT 50;
    
-- Task 5 --
SELECT DISTINCT(name) 
	FROM performances p
	JOIN teams t ON p.team_id = t.id
    WHERE p.player_id = (
		SELECT id FROM players
			WHERE first_name  LIKE '%Satchel%'
            AND last_name LIKE '%Paige%'
		);
        
-- Task 6 --
SELECT t.name AS team_name, SUM(p.H) AS total_hits
	FROM teams t
	LEFT JOIN performances p ON t.id = p.team_id
	WHERE p.year = 2001
	GROUP BY t.name
	ORDER BY total_hits DESC
	LIMIT 5;
    
-- Task 7 --
SELECT first_name, last_name FROM players p
	JOIN salaries s ON p.id = s.player_id
    ORDER BY salary DESC
    LIMIT 1;
	
-- Task 8 --
SELECT salary FROM salaries s
	JOIN performances p ON s.player_id = p.player_id
    WHERE p.year = 2001
    ORDER BY HR DESC
    LIMIT 1;
    
-- Task 9 --
SELECT name, AVG(salary) AS average_salary FROM salaries s
	JOIN teams t ON s.team_id = t.id
    WHERE s.year = 2001
	GROUP BY team_id
    ORDER BY average_salary ASC
    LIMIT 5;

-- Task 10 --
SELECT DISTINCT(p.id), first_name, last_name, salary, HR, s.year FROM players p
	JOIN salaries s ON p.id = s.player_id
    JOIN performances pf ON p.id = pf.player_id
    ORDER BY p.id, s.year DESC, HR DESC, salary ASC;
    
-- Task 11 --
SELECT first_name, last_name, ROUND((s.salary / H), 2) AS dollars_per_hit 
	FROM players p
	JOIN salaries s ON p.id = s.player_id
    JOIN performances pf ON p.id = pf.player_id
    WHERE pf.H > 0 AND pf.year = 2001
    ORDER BY dollars_per_hit ASC, first_name, last_name;
    
-- Task 12 --
WITH CostPerHit AS (
    SELECT 
        p.id AS player_id, 
        p.first_name, 
        p.last_name,
        (s.salary / NULLIF(pf.H, 0)) AS cost_per_hit
    FROM players p
    JOIN salaries s ON p.id = s.player_id
    JOIN performances pf ON p.id = pf.player_id
    WHERE s.year = 2001 AND pf.year = 2001
),
CostPerRBI AS (
    SELECT 
        p.id AS player_id, 
        p.first_name, 
        p.last_name,
        (s.salary / NULLIF(pf.RBI, 0)) AS cost_per_rbi
    FROM players p
    JOIN salaries s ON p.id = s.player_id
    JOIN performances pf ON p.id = pf.player_id
    WHERE s.year = 2001 AND pf.year = 2001
),
Top10PerHit AS (
    SELECT player_id, first_name, last_name
    FROM CostPerHit
    ORDER BY cost_per_hit
    LIMIT 10
),
Top10PerRBI AS (
    SELECT player_id, first_name, last_name
    FROM CostPerRBI
    ORDER BY cost_per_rbi
    LIMIT 10
)
SELECT DISTINCT first_name, last_name
	FROM Top10PerHit UNION
	SELECT DISTINCT first_name, last_name
	FROM Top10PerRBI
	ORDER BY last_name, first_name;