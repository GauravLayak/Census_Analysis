--Create a District Table--
DROP TABLE IF EXISTS district;

CREATE TABLE district (
	District VARCHAR(30),
	States VARCHAR(30),
	Area_km2 INT,
	Population INT
);

--Create a literacy Table--
DROP TABLE IF EXISTS literacy;

CREATE TABLE literacy (
	District VARCHAR(30),
	States VARCHAR(30),
	Growth FLOAT,
	Sex_Ratio INT,
	Literacy FLOAT
);

SELECT * FROM literacy;

SELECT * FROM district
where states like '%Not Provided%';

--FINDING COMMON METRICS--

-- Population of India
SELECT SUM(population) AS total_pop
FROM district;

-- Avg growth
SELECT states,
	AVG(growth)*100 AS avg_growth
FROM literacy
GROUP BY 1;

-- Avg Sex ratio
SELECT states,
	ROUND(AVG(sex_ratio), 0) AS avg_sex_ratio
FROM literacy
GROUP BY 1
ORDER BY 2 DESC;

-- Avg literacy rate of each states and states having avg literacy rate > 90
SELECT states,
	AVG(literacy) AS avg_literacy_rate
FROM literacy
GROUP BY 1
ORDER BY 2 DESC;

SELECT states,
	AVG(literacy) AS avg_literacy_rate
FROM literacy
GROUP BY 1
HAVING AVG(literacy) > 90
ORDER BY 2 DESC;

-- Top 3 states showing highest growth ratio
SELECT states,
	AVG(growth)*100 AS avg_growth_ratio
FROM literacy
GROUP BY 1
ORDER BY 2 DESC
LIMIT 3;

-- Bottom 3 states showing lowest sex ratio
SELECT states,
	ROUND(AVG(sex_ratio), 0) AS avg_sex_ratio
FROM literacy
GROUP BY 1
ORDER BY 2
LIMIT 3;

-- Top and Bottom 3 states in literacy ratio
DROP TABLE IF EXISTS topstates;

CREATE TABLE topstates (
	state VARCHAR(30),
	topstate FLOAT
);

INSERT INTO topstates 
SELECT states, 
	AVG(literacy) AS avg_literacy_ratio FROM literacy
GROUP BY 1
ORDER BY 2 DESC;

SELECT * FROM topstates 
ORDER BY topstate DESC
LIMIT 3;

DROP TABLE IF EXISTS bottomstates;

CREATE TABLE bottomstates (
	state VARCHAR(30),
	bottomstate FLOAT
);

INSERT INTO bottomstates 
SELECT states, 
	AVG(literacy) AS avg_literacy_ratio FROM literacy
GROUP BY 1
ORDER BY 2 DESC;

SELECT * FROM bottomstates 
ORDER BY bottomstate
LIMIT 3;

-- Union operator to combine above to tables
SELECT * FROM (
	SELECT * FROM topstates 
	ORDER BY topstate DESC
	LIMIT 3 ) AS a
UNION ALL
SELECT * FROM (
	SELECT * FROM bottomstates 
	ORDER BY bottomstate
	LIMIT 3 ) AS b;

-- State starting with letter 'A' and 'B'
SELECT DISTINCT states 
FROM literacy
WHERE states LIKE '%A%'
OR 
states LIKE '%B%'
ORDER BY 1;

-- State starting with letter 'M' and ending with 'A'
SELECT DISTINCT states 
FROM literacy
WHERE states LIKE 'M%'
AND
states ILIKE '%A';

--SOME INTERMEDIATE DATA EXPLORATIONS AND STATISTICAL ANALYSIS--

-- Total Literacy ratio--

SELECT * FROM district
SELECT * FROM literacy;

SELECT d.states,
	SUM(literate_people) AS total_literate,
	SUM(illiterate_people) AS total_illeterate 
		FROM (
					SELECT c.district,
						c.states,
						ROUND(c.literacy_ratio * c.population) AS literate_people,
						ROUND((1-c.literacy_ratio) * c.population) AS illiterate_people 
						FROM (
							SELECT a.district,
								a.states,
								a.literacy/100 AS literacy_ratio,
								b.population
							FROM literacy AS a
							INNER JOIN district AS b
							ON a.district = b.district ) AS c ) AS d
			GROUP BY 1
			ORDER BY 1;

-- Population in previous census

SELECT SUM(e.previous_census_pop) AS previous_census_pop,
		SUM(e.current_census_pop) AS current_census_pop
	FROM (
		SELECT d.states,
			SUM(d.previous_census_pop) AS previous_census_pop,
			SUM(d.current_census_pop) AS current_census_pop
			FROM ( 
				SELECT c.district,
					c.states,
					ROUND(c.population/(1- c.growth)) AS previous_census_pop,
					c.population AS current_census_pop 
					FROM ( 
							SELECT a.district,
								a.states,
								a.growth,
								b.population 
							FROM literacy AS a
							INNER JOIN district AS b
							ON a.district = b.district ) AS c ) AS d
			GROUP BY 1 ) AS e;

--Population vs area

SELECT j.total_area/j.previous_census_pop AS previous_census_pop_vs_area,
	j.total_area/j.current_census_pop AS current_census_pop_vs_area
FROM (
		SELECT h.*,
			i.total_area FROM (
				SELECT '1' AS keyy,
					f.*
					FROM ( 
						SELECT SUM(e.previous_census_pop) AS previous_census_pop,
								SUM(e.current_census_pop) AS current_census_pop
							FROM (
								SELECT d.states,
									SUM(d.previous_census_pop) AS previous_census_pop,
									SUM(d.current_census_pop) AS current_census_pop
									FROM ( 
										SELECT c.district,
											c.states,
											ROUND(c.population/(1- c.growth)) AS previous_census_pop,
											c.population AS current_census_pop 
											FROM ( 
													SELECT a.district,
														a.states,
														a.growth,
														b.population 
													FROM literacy AS a
													INNER JOIN district AS b
													ON a.district = b.district ) AS c ) AS d
									GROUP BY 1 ) AS e ) AS f ) AS h 
		
		INNER JOIN 
		( SELECT '1' AS keyy,
			g.* 
			FROM ( 
				SELECT SUM(Area_km2) AS total_area 
				FROM district ) AS g ) AS i
		ON h.keyy = i.keyy ) AS j; 

-- Now they both have common column 'keyy'


--END OF PROJECT--



























