MODEL (
  name silver.fatalities,
  kind VIEW,
);

SELECT
  crash_id AS crash_id,

  road_user AS road_user,

  -- Set unknonwn age to NULL
  CASE age
    WHEN -9 THEN NULL
    ELSE age::INT
  END AS age,

  -- Set unknown gender to NULL
  CASE gender
    WHEN 'Unknown' THEN NULL
    ELSE gender
  END AS gender
FROM bronze.fatalities;
