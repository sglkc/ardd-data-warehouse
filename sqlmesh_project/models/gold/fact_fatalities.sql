MODEL (
  name gold.fact_fatalities,
  kind VIEW,
);

SELECT
  p.person_key,
  f.*
FROM silver.fatalities f
LEFT JOIN gold.dim_person p ON p.person_key = @GENERATE_SURROGATE_KEY(f.road_user, f.age, f.gender);
