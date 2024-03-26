with
    source as (select * from {{ ref("fct_observations") }}),

    aggregated_temperatures as (
        select
            station_id,
            extract(year from date) as year,
            extract(month from date) as month,
            max(tmax) as max_temp_monthly,
            min(tmin) as min_temp_monthly,
            avg(tmax) as avg_tmax_monthly,
            avg(tmin) as avg_tmin_monthly,
            avg(tavg) as avg_tavg_monthly
        from source
        group by station_id, year, month
        order by station_id, year, month
    )

select *
from aggregated_temperatures
where coalesce(max_temp_monthly, min_temp_monthly, avg_tmax_monthly, avg_tmin_monthly, avg_tavg_monthly) is not null

{% if var("is_test_run", default=true) %}
limit 500
{% endif %}
