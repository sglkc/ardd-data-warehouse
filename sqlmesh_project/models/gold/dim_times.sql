MODEL (
  name gold.dim_times,
  kind VIEW,
  grain [hour_24, minute_num]
);

WITH minutes AS (
    -- Generate 0–1439 minutes of the day
    SELECT generate_series(0, 1439) AS minute_of_day
)

SELECT
  LPAD((minute_of_day / 60)::text, 2, '0') ||
    LPAD((minute_of_day % 60)::text, 2, '0') AS time_key,   -- 'HHMM' format surrogate key

  (minute_of_day / 60) % 12 AS hour_12,
  (minute_of_day / 60)      AS hour_24,
  (minute_of_day % 60)      AS minute_num,
  minute_of_day,
  CASE
    WHEN (minute_of_day / 60) >= 12 THEN 'pm'
    ELSE 'am'
  END AS am_pm,
  CASE
    WHEN minute_of_day < 360  THEN 'night'      -- before 06:00
    WHEN minute_of_day < 720  THEN 'morning'    -- before 12:00
    WHEN minute_of_day < 900  THEN 'afternoon'  -- before 15:00
    WHEN minute_of_day < 1260 THEN 'evening'    -- before 21:00
    ELSE 'night'
  END AS time_bucket,
  CASE
    WHEN minute_of_day BETWEEN 360  AND 539  THEN 'peak_morning'   -- 06:00–08:59
    WHEN minute_of_day BETWEEN 960  AND 1139 THEN 'peak_evening'   -- 16:00–18:59
    ELSE 'off_peak'
  END AS peak_offpeak
FROM minutes;
