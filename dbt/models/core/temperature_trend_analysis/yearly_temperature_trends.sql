with
    source as (select * from {{ ref("fct_observations") }}),

    aggregated_temperatures as (
        select
            station_id,
            extract(year from date) as year,
            max(tmax) as max_temp_yearly,
            min(tmin) as min_temp_yearly,
            avg(tmax) as avg_tmax_yearly,
            avg(tmin) as avg_tmin_yearly,
            avg(tavg) as avg_tavg_yearly
        from source
        group by station_id, year
        order by station_id, year
    )

select *
from aggregated_temperatures
where coalesce(max_temp_yearly, min_temp_yearly, avg_tmax_yearly, avg_tmin_yearly, avg_tavg_yearly) is not null

{% if var("is_test_run", default=true) %}
limit 500
{% endif %}
