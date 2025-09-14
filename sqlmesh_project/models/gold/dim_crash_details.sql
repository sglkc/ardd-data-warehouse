MODEL (
  name gold.dim_crash_details,
  kind VIEW,
);

SELECT DISTINCT
  @GENERATE_SURROGATE_KEY(c.crash_type, c.speed_limit, c.road_type) AS crash_detail_key,
	c.crash_type AS crash_type,
	c.speed_limit AS speed_limit,
	c.road_type AS road_type
FROM silver.crashes c
