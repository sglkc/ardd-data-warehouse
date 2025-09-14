MODEL (
  name gold.dim_victims,
  kind FULL,
);

SELECT DISTINCT
  @GENERATE_SURROGATE_KEY(f.road_user, f.age, f.gender) AS victim_key,
  f.road_user,
  f.age,
  f.gender
FROM silver.fatalities f
