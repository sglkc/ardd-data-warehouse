MODEL (
  name gold.dim_person,
  kind VIEW,
);

SELECT DISTINCT
  @GENERATE_SURROGATE_KEY(f.road_user, f.age, f.gender) AS person_key,
  f.road_user,
  f.age,
  f.gender
FROM silver.fatalities f
