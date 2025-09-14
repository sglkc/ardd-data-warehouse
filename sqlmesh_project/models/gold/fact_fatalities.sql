MODEL (
  name gold.fact_fatalities,
  kind VIEW,
);

SELECT
  f.crash_id AS source_id,
  tp.time_period_key,
  t.time_key,
  cd.crash_detail_key,
  l.location_key,
  vi.vehicle_involvement_key,
  p.person_key
FROM silver.fatalities f
LEFT JOIN gold.dim_time_periods tp
  ON tp.year = f.year AND tp.month_num = f.month AND tp.day_of_week_name = f.dayweek
LEFT JOIN gold.dim_times t
  ON t.full_time = f.time
LEFT JOIN gold.dim_crash_details cd
  ON cd.crash_detail_key = @GENERATE_SURROGATE_KEY(f.crash_type, f.speed_limit, f.road_type)
LEFT JOIN gold.dim_locations l
  ON l.location_key = @GENERATE_SURROGATE_KEY(f.state, f.remoteness_area, f.statistical_area, f.local_government_area)
LEFT JOIN gold.dim_vehicle_involvements vi
  ON vi.vehicle_involvement_key = @GENERATE_SURROGATE_KEY(f.bus_involvement, f.heavy_rigid_truck_involvement, f.articulated_truck_involvement)
LEFT JOIN gold.dim_person p
  ON p.person_key = @GENERATE_SURROGATE_KEY(f.road_user, f.age, f.gender)
