-- ============================================================
-- Project: AWS ETL Data Lake Analytics
-- Dataset: NOAA GHCN-D Weather Data
-- Services: AWS Glue, Amazon Athena, Amazon S3
-- Purpose: Transform weather data into Parquet format and
--          analyze annual maximum temperature observations.
-- ============================================================


-- ============================================================
-- 1. Explore the source dataset
-- ============================================================

SELECT *
FROM weatherdata.by_year
LIMIT 10;


-- ============================================================
-- 2. Transform the source dataset into Parquet format
--    Filter records to the period 1950–2015.
--    Store the transformed data in Amazon S3.
-- ============================================================

CREATE TABLE weatherdata.late20th
WITH (
    format = 'PARQUET',
    external_location = 's3://glue-1950-bucket--d6bdbcd0/lab3'
) AS
SELECT
    date,
    type,
    observation
FROM weatherdata.by_year
WHERE date / 10000 BETWEEN 1950 AND 2015;


/*
Execution Results:
- Queue Time: Not provided
- Run Time: 30.184 seconds
- Data Scanned: 106.19 GB
*/


-- ============================================================
-- 3. Validate the transformed dataset
-- ============================================================

SELECT *
FROM weatherdata.late20th
LIMIT 10;


-- ============================================================
-- 4. Inspect the TMAX view
--    TMAX contains maximum-temperature observations.
-- ============================================================

SELECT *
FROM weatherdata.tmax
LIMIT 10;


-- ============================================================
-- 5. Analyze annual average maximum temperatures
--    Convert observations from tenths of a degree Celsius
--    to degrees Celsius by dividing by 10.
-- ============================================================

SELECT
    date / 10000 AS year,
    AVG(observation) / 10 AS max
FROM weatherdata.tmax
GROUP BY date / 10000
ORDER BY date / 10000;


/*
Execution Results:
- Queue Time: 100 ms
- Run Time: 9.714 seconds
- Data Scanned: 2.36 GB
*/
