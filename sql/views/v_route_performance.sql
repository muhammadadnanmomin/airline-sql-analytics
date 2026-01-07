USE airline_analytics;

CREATE OR REPLACE VIEW v_route_performance AS
SELECT
    ao.airport_code AS origin,
    ad.airport_code AS destination,

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
JOIN airports_dim ao ON f.origin_airport_id = ao.airport_id
JOIN airports_dim ad ON f.dest_airport_id   = ad.airport_id
GROUP BY ao.airport_code, ad.airport_code;
