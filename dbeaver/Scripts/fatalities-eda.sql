SELECT * FROM fatalities;

--=== Person/Victim Dimension ===---

-- Check possible road_users
SELECT road_user, COUNT(*) FROM fatalities GROUP BY road_user;
-- Result: Just like the data dictionary

-- What are the possible values of age?
SELECT age, COUNT(*) FROM fatalities GROUP BY age ORDER BY age;
-- Result: -9 represents Unknown
-- TODO: is there a better way to represent this?

-- Check any invalid gender
SELECT gender, COUNT(*) FROM fatalities GROUP BY gender;
-- Result: Only 'Unknown', 'Male', 'Female'

--=== Crash Details Dimension ===---

-- Are there invalid crash types?
SELECT crash_type, COUNT(*) FROM fatalities GROUP BY crash_type;
-- Result: No, just like the data dictionary, possible values are 'Single', 'Multiple', or 'Unknown'

-- What are possible speed limits?
SELECT speed_limit , COUNT(*) FROM fatalities GROUP BY speed_limit;
-- Result: -9 represents unknown speed_limit
-- TODO: is there a better way to represent this?

-- What are possible national road types?
SELECT national_road_type, COUNT(*) FROM fatalities GROUP BY national_road_type;
-- Result: Just like what the data dictionary described.

--=== Vehicle Involvements Dimension ===---

-- Check possible combinations of vehicle involvements
SELECT bus_involvement,
heavy_rigid_truck_involvement,
articulated_truck_involvement,
COUNT(*)
FROM fatalities
GROUP BY bus_involvement, heavy_rigid_truck_involvement, articulated_truck_involvement
ORDER BY bus_involvement, heavy_rigid_truck_involvement, articulated_truck_involvement;
-- Result: Replace -9 with Unknown OR NULL for boolean flags

--=== Location Dimension ===---

-- Are there unknown states?
SELECT state, LENGTH(state), COUNT(state) FROM fatalities GROUP BY state;
-- Result: No

-- Check unknown locations
SELECT DISTINCT
  national_remoteness_areas_2021,
  sa4_name_2021,
  national_lga_name_2021,
  COUNT(*)
FROM fatalities
WHERE national_remoteness_areas_2021 = 'Unknown' OR
sa4_name_2021 = 'Unknown' OR
national_lga_name_2021 = 'Unknown'
GROUP BY national_remoteness_areas_2021, sa4_name_2021, national_lga_name_2021
ORDER BY COUNT(*) DESC;
-- Result: Possible unknown collections: (ra, sa4, lga), (ra, sa4), (lga)

--=== Date/Time Period Dimension ===---

-- Whats the start year?
SELECT MIN(YEAR) FROM fatalities;
-- Result: The dataset starts from 1989

-- Are there invalid month or years?
SELECT MONTH, YEAR FROM fatalities WHERE MONTH NOT BETWEEN 1 AND 12 OR YEAR NOT BETWEEN 1989 AND 2025;
-- Result: No, but there is no date column

-- Are there invalid dayweek?
SELECT dayweek FROM fatalities
WHERE LOWER(dayweek) NOT IN ('sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday');
-- Result: Noe

-- Are there invalid periods?
SELECT christmas_period, easter_period FROM fatalities
WHERE christmas_period NOT IN ('No', 'Yes') AND easter_period NOT IN ('No', 'Yes');
-- Result: No

-- Let's create a view for date dimension
SELECT MONTH, YEAR, dayweek, christmas_period, easter_period FROM fatalities;

--=== TIME DIMENSION ===---

-- See if time format has seconds precision
SELECT time FROM fatalities WHERE time NOT LIKE '%:00';
-- Result: No, but unknown time is set to 99:99:99

-- What happens if time is casted as TIME data type?
SELECT time::TIME FROM fatalities WHERE time NOT LIKE '%:00';
-- Result: Doesn't work, must transform

-- Set time to nullable for unknown
SELECT
  CASE
    WHEN time NOT LIKE '%:00' THEN NULL 
    ELSE time::TIME
  END AS time
FROM fatalities WHERE time NOT LIKE'%:00';

-- Create view for time dimension
SELECT 
  EXTRACT(HOUR FROM time::TIME) % 12 AS hour_12,
  EXTRACT(HOUR FROM time::TIME) AS hour_24,
  EXTRACT(MINUTE FROM time::TIME) AS minute_num,
  EXTRACT(HOUR FROM time::TIME) * 60 + EXTRACT(MINUTE FROM time::TIME) AS minute_of_day,
  CASE 
    WHEN EXTRACT(HOUR FROM time::TIME) > 12 THEN 'pm'
    ELSE 'am' 
  END AS am_pm,
  CASE
    WHEN time::TIME < '06:00' THEN 'night'
    WHEN time::TIME < '12:00' THEN 'morning'
    WHEN time::TIME < '15:00' THEN 'afternoon'
    WHEN time::TIME < '21:00' THEN 'evening'
    ELSE 'night'
  END AS time_bucket
FROM fatalities;



