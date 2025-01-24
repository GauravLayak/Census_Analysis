# Census Data Management and Analysis

## Objective
This repository contains SQL scripts for managing and analyzing census data. The project provides insights into district-wise population, literacy rates, and socio-economic indicators, using an optimized relational database schema.

## Project Structure
### Database Setup

- **Database Creation**: The project starts by creating a database named `census_db`.
- **Tables Creation**:
  **district table**:
```sql
DROP TABLE IF EXISTS district;
CREATE TABLE district (
	District VARCHAR(30),
	States VARCHAR(30),
	Area_km2 INT,
	Population INT
);
```

 **literacy table**:
 ```sql
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
```

### Data Analysis & Findings :
## Key Questions :

1. **What is the Population of India?**  
```sql
SELECT SUM(population) AS total_pop
FROM district;
```

2. **What is the Average growth of each States?**
```sql
SELECT states,
	AVG(growth)*100 AS avg_growth
FROM literacy
GROUP BY 1;
```

3. **What is the Average Sex ratio of each states?**
```sql
SELECT states,
	ROUND(AVG(sex_ratio), 0) AS avg_sex_ratio
FROM literacy
GROUP BY 1
ORDER BY 2 DESC;
```

4. **What is the Average literacy rate of each states and which states is having average literacy rate > 90?**
```sql
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
```

5. **Top 3 states showing highest growth ratio**
```sql
SELECT states,
	AVG(growth)*100 AS avg_growth_ratio
FROM literacy
GROUP BY 1
ORDER BY 2 DESC
LIMIT 3;
```

6. **Bottom 3 states showing lowest sex ratio**
```sql
SELECT states,
	ROUND(AVG(sex_ratio), 0) AS avg_sex_ratio
FROM literacy
GROUP BY 1
ORDER BY 2
LIMIT 3;
```

7. **Top and Bottom 3 states in literacy ratio**
```sql
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

**Union operator to combine above to tables**
SELECT * FROM (
	SELECT * FROM topstates 
	ORDER BY topstate DESC
	LIMIT 3 ) AS a
UNION ALL
SELECT * FROM (
	SELECT * FROM bottomstates 
	ORDER BY bottomstate
	LIMIT 3 ) AS b;
```

8a. **States starting with letter 'A' and 'B'**
```sql
SELECT DISTINCT states 
FROM literacy
WHERE states LIKE '%A%'
OR 
states LIKE '%B%'
ORDER BY 1;
```

8b. **States starting with letter 'M' and ending with 'A'**
```sql
SELECT DISTINCT states 
FROM literacy
WHERE states LIKE 'M%'
AND
states ILIKE '%A';
```

### SOME INTERMEDIATE DATA EXPLORATIONS AND STATISTICAL ANALYSIS

9. **What is Total Literacy ratio**
```sql
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
```

10. **What is the Population in previous census vs Population in current census**
```sql
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
```
11. **What is the current Population vs area and previous Population vs area**
```sql
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
```

## Core Features :
- Structured relational database for census data.
- Analysis-ready tables for district-wise demographics and literacy rates.
- Queries for:
     1. Identifying districts with low literacy rates.
     2. Aggregating population and growth data at the state and national levels.
     3. Analyzing gender ratios and population distributions.


## Conclusion
This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, exploratory data analysis, and data-driven SQL queries. The findings from this project can help drive insightful decisions by understanding previous vs current census patterns, literacy ratio , and states performances and other key indicators.

