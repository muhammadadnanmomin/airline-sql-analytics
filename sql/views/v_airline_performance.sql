USE airline_analytics;

CREATE OR REPLACE VIEW v_airline_performance AS
SELECT
    a.airline_code,

    SUM(f.total_flights) AS total_flights,

    ROUND(
        SUM(f.avg_arr_delay * f.total_flights)
        / NULLIF(SUM(f.total_flights), 0),
        2
    ) AS weighted_avg_arr_delay,

    ROUND(
        SUM(f.avg_dep_delay * f.total_flights)
        / NULLIF(SUM(f.total_flights), 0),
        2
    ) AS weighted_avg_dep_delay,

    ROUND(
        SUM(f.cancelled_flights)
        / NULLIF(SUM(f.total_flights), 0) * 100,
        2
    ) AS cancellation_rate_pct,

    ROUND(
        SUM(f.diverted_flights)
        / NULLIF(SUM(f.total_flights), 0) * 100,
        2
    ) AS diversion_rate_pct

FROM flights_fact_daily f
JOIN airlines_dim a
  ON f.airline_id = a.airline_id
GROUP BY a.airline_code;
