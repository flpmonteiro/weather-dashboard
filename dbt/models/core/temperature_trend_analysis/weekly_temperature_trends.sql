with
    source as (select * from {{ ref("fct_observations") }}),

    aggregated_temperatures as (
        select
            station_id,
            extract(year from date) as year,
            extract(week from date) as week,
            max(tmax) as max_temp_weekly,
            min(tmin) as min_temp_weekly,
            avg(tmax) as avg_tmax_weekly,
            avg(tmin) as avg_tmin_weekly,
            avg(tavg) as avg_tavg_weekly
        from source
        group by station_id, year, week
        order by station_id, year, week
    )

select *
from aggregated_temperatures
where coalesce(max_temp_weekly, min_temp_weekly, avg_tmax_weekly, avg_tmin_weekly, avg_tavg_weekly) is not null

{% if var("is_test_run", default=true) %}
limit 500
{% endif %}
