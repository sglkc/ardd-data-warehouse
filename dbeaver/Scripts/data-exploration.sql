-- Check crashes with multiple fatalities
SELECT crash_id, COUNT(crash_id) FROM fatalities f GROUP BY crash_id HAVING COUNT(crash_id) > 1;
-- Result: crash_id is NOT the primary key, but its a reference to the crash, based on the data dictionary, each row is a fatality.

-- Analyze data with multiple fatalities
SELECT * FROM fatalities f WHERE crash_id = 120_151_083_536;
-- Result: It might be possible to merge the data with (crash_id, road_user, gender, age) as merge keys

-- See if filtering by crash_type is possible
SELECT * FROM fatalities f WHERE crash_type = 'Multiple' ORDER BY crash_id;
-- Result: No. Based on the data dictionary, crash_type only describes number of vehicles, not fatalities

-- The dictionary there is Number Fatalities to multiple fatalities, but its not in the dataset
SELECT DISTINCT crash_id, road_user, gender, age FROM fatalities f ORDER BY crash_id;

-- It's possible to use these columns, but what are the cases of the same gender and age?
SELECT crash_id, COUNT(*) FROM fatalities f GROUP BY crash_id, road_user, gender, age HAVING COUNT(*) > 2;
-- Result: There are some cases (only 8) of where these columns have the same values, how do we handle them?

-- Let's see
SELECT * FROM fatalities f WHERE f.crash_id IN (7053889719453153980, 3199410240286, 1200007140299, 2198901050008) ORDER BY crash_id;

-- Yeah no need to overthink, just do Full load method instead of merging, it aint serious