MODEL (
  name gold.dim_time_periods,
  kind VIEW,
  grain [time_period_key]
);


WITH dates AS (
  SELECT generate_series(
    '1989-01-01'::date,
    NOW()::date,
    interval '1 day'
  ) AS full_date
)

SELECT DISTINCT
  -- surrogate key
  TO_CHAR(full_date, 'YYYYMMD') AS time_period_key,

  -- basic date parts
  TO_CHAR(full_date, 'YYYY-MM') AS year_month,
  EXTRACT(YEAR FROM full_date) AS year,
  EXTRACT(MONTH FROM full_date) AS month_num,
  TRIM(TO_CHAR(full_date, 'Month')) AS month_name,
  EXTRACT(DOW FROM full_date)+1 AS day_of_week_num,
  TRIM(TO_CHAR(full_date, 'Day')) AS day_of_week_name,

  -- higher-level groupings
  EXTRACT(QUARTER FROM full_date) AS quarter_num,
  'Q' || EXTRACT(QUARTER FROM full_date) AS quarter_name,

  CASE
    WHEN EXTRACT(MONTH FROM full_date) BETWEEN 1 AND 6 THEN 1
    ELSE 2
  END AS semester,

  CASE
    WHEN EXTRACT(DOW FROM full_date) BETWEEN 1 AND 4 THEN 'Early week'
    ELSE 'Late week'
  END AS week_bucket,

  CASE
    WHEN EXTRACT(DOW FROM full_date) IN (0, 6) THEN TRUE
    ELSE FALSE
  END AS is_weekend,

  -- seasonal
  CASE
    WHEN EXTRACT(MONTH FROM full_date) IN (12, 1, 2) THEN 'Summer'
    WHEN EXTRACT(MONTH FROM full_date) IN (3, 4, 5) THEN 'Fall'
    WHEN EXTRACT(MONTH FROM full_date) IN (6, 7, 8) THEN 'Winter'
    ELSE 'Spring'
  END AS season

FROM dates;
