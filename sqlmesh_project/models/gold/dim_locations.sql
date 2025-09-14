MODEL (
  name gold.dim_locations,
  kind VIEW,
);

SELECT DISTINCT
  @GENERATE_SURROGATE_KEY(c.state, c.remoteness_area, c.statistical_area, c.local_government_area) AS location_key,
  c.state,
  c.remoteness_area,
  c.statistical_area,
  c.local_government_area
FROM silver.crashes c
