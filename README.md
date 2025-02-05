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

2. **What is the Average growth of each States?**

3. **What is the Average Sex ratio of each states?**

4. **What is the Average literacy rate of each states and which states is having average literacy rate > 90?**

5. **Top 3 states showing highest growth ratio**

6. **Bottom 3 states showing lowest sex ratio**

7. **Top and Bottom 3 states in literacy ratio**

8a. **States starting with letter 'A' and 'B'**

8b. **States starting with letter 'M' and ending with 'A'**


### SOME INTERMEDIATE DATA EXPLORATIONS AND STATISTICAL ANALYSIS

9. **What is Total Literacy ratio**

10. **What is the Population in previous census vs Population in current census**

11. **What is the current Population vs area and previous Population vs area**


## Core Features :
- Structured relational database for census data.
- Analysis-ready tables for district-wise demographics and literacy rates.
- Queries for:
     1. Identifying districts with low literacy rates.
     2. Aggregating population and growth data at the state and national levels.
     3. Analyzing gender ratios and population distributions.


## Conclusion
This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, exploratory data analysis, and data-driven SQL queries. The findings from this project can help drive insightful decisions by understanding previous vs current census patterns, literacy ratio , and states performances and other key indicators.

