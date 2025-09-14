MODEL (
  name gold.dim_vehicle_involvements,
  kind VIEW,
);

SELECT DISTINCT
  @GENERATE_SURROGATE_KEY(
    c.bus_involvement,
    c.heavy_rigid_truck_involvement,
    c.articulated_truck_involvement
  ) AS vehicle_involvement_key,
  c.bus_involvement AS bus,
	c.heavy_rigid_truck_involvement AS heavy_rigid_truck,
	c.articulated_truck_involvement AS articulated_truck
FROM silver.crashes c;
