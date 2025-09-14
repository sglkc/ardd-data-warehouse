MODEL (
  name gold.fact_fatalities,
  kind VIEW,
);

SELECT
  tp.time_period_key,
  t.time_key,
  cd.crash_detail_key,
  l.location_key,
  vi.vehicle_involvement_key,
  p.person_key
FROM silver.fatalities f
LEFT JOIN silver.crashes c
  ON c.crash_id = f.crash_id
LEFT JOIN gold.dim_time_periods tp
  ON tp.year = c.year AND tp.month_num = c.month AND tp.day_of_week_name = c.dayweek
LEFT JOIN gold.dim_times t
  ON t.full_time = c.time
LEFT JOIN gold.dim_crash_details cd
  ON cd.crash_detail_key = @GENERATE_SURROGATE_KEY(c.crash_type, c.speed_limit, c.road_type)
LEFT JOIN gold.dim_locations l
  ON l.location_key = @GENERATE_SURROGATE_KEY(c.state, c.remoteness_area, c.statistical_area, c.local_government_area)
LEFT JOIN gold.dim_vehicle_involvements vi
  ON vi.vehicle_involvement_key = @GENERATE_SURROGATE_KEY(c.bus_involvement, c.heavy_rigid_truck_involvement, c.articulated_truck_involvement)
LEFT JOIN gold.dim_person p
  ON p.person_key = @GENERATE_SURROGATE_KEY(f.road_user, f.age, f.gender)
