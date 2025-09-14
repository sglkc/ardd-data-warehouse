MODEL (
  name silver.fatalities,
  kind VIEW,
);

SELECT
  crash_id AS crash_id,

  -->> time period dimension
  month::INT AS month,
	year::INT AS year,
	dayweek AS dayweek,

  -- Cast string time hh:mm:ss to TIME data type, set unknown to null
  CASE time
    WHEN '99:99:99' THEN NULL
    ELSE time::TIME
  END AS time,

  -- Cast string to boolean flags, set unknown to null
  CASE christmas_period
    WHEN 'Yes' THEN TRUE
    WHEN 'No' THEN FALSE
    ELSE NULL
  END AS christmas_period,

  CASE easter_period
    WHEN 'Yes' THEN TRUE
    WHEN 'No' THEN FALSE
    ELSE NULL
  END AS easter_period,

  -->> vehicle involvements
  -- Cast string to boolean flags, set unknown to null
  CASE bus_involvement
    WHEN 'Yes' THEN TRUE
    WHEN 'No' THEN FALSE
    ELSE NULL
  END AS bus_involvement,

  CASE heavy_rigid_truck_involvement
    WHEN 'Yes' THEN TRUE
    WHEN 'No' THEN FALSE
    ELSE NULL
  END AS heavy_rigid_truck_involvement,

  CASE articulated_truck_involvement
    WHEN 'Yes' THEN TRUE
    WHEN 'No' THEN FALSE
    ELSE NULL
  END AS articulated_truck_involvement,

  -->> crash details
	crash_type AS crash_type,
	speed_limit AS speed_limit,
	national_road_type AS road_type,

  -->> location dimension
  state AS state,
	national_remoteness_areas_2021 AS remoteness_area,
	sa4_name_2021 AS statistical_area,
	national_lga_name_2021 AS local_government_area,

  -->> victim dimension
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
