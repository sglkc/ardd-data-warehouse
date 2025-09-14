MODEL (
  name gold.dim_locations,
  kind VIEW,
);

SELECT DISTINCT
  @GENERATE_SURROGATE_KEY(
    f.state,
    f.remoteness_area,
    f.statistical_area,
    f.local_government_area
  ) AS location_key,
  f.state,
  f.remoteness_area,
  f.statistical_area,
  f.local_government_area
FROM silver.fatalities f
