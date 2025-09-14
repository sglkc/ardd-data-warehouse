MODEL (
  name gold.dim_vehicle_involvements,
  kind VIEW,
);

SELECT DISTINCT
  @GENERATE_SURROGATE_KEY(
    f.bus_involvement,
    f.heavy_rigid_truck_involvement,
    f.articulated_truck_involvement
  ) AS vehicle_involvement_key,
  f.bus_involvement AS bus,
	f.heavy_rigid_truck_involvement AS heavy_rigid_truck,
	f.articulated_truck_involvement AS articulated_truck
FROM silver.fatalities f;
