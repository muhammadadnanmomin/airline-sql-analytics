USE airline_analytics;

CREATE OR REPLACE VIEW v_airport_performance AS
SELECT
    ap.airport_code AS airport,

    SUM(f.total_flights) AS total_flights,

    ROUND(
        SUM(f.avg_arr_delay * f.total_flights)
        / NULLIF(SUM(f.total_flights), 0),
        2
    ) AS weighted_avg_arr_delay,

    ROUND(
        SUM(f.cancelled_flights)
        / NULLIF(SUM(f.total_flights), 0) * 100,
        2
    ) AS cancellation_rate_pct

FROM flights_fact_daily f
JOIN airports_dim ap
  ON f.origin_airport_id = ap.airport_id
GROUP BY ap.airport_code;
