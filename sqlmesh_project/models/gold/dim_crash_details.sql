MODEL (
  name gold.dim_crash_details,
  kind FULL,
);

SELECT DISTINCT
  @GENERATE_SURROGATE_KEY(f.crash_type, f.speed_limit, f.road_type) AS crash_detail_key,
	f.crash_type AS crash_type,
	f.speed_limit AS speed_limit,
	f.road_type AS road_type
FROM silver.fatalities f
