with
    source as (select * from {{ ref("fct_observations") }}),

    aggregated_temperatures as (
        select
            station_id,
            date,
            max(tmax) as max_temp,
            min(tmin) as min_temp,
            avg(tmax) as avg_tmax,
            avg(tmin) as avg_tmin,
            avg(tavg) as avg_tavg
        from source
        group by station_id, date
        order by station_id, date
    )

select *
from aggregated_temperatures
where coalesce(max_temp, min_temp, avg_tmax, avg_tmin, avg_tavg) is not null

{% if var("is_test_run", default=true) %}
limit 500
{% endif %}
