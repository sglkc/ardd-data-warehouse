MODEL (
  name gold.fact_fatalities,
  kind VIEW,
);

SELECT
  p.person_key,
  TO_CHAR(c.time, 'HH24MI') AS time_key
FROM silver.fatalities f
LEFT JOIN silver.crashes c
  ON c.crash_id = f.crash_id
LEFT JOIN gold.dim_person p
  ON p.person_key = @GENERATE_SURROGATE_KEY(f.road_user, f.age, f.gender)
