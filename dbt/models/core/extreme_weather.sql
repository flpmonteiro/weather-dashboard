with
    source as (select * from {{ ref("fct_observations") }}),

    weather_data as (
        select
            station_id,
            date,
            max(tmax) as max_temp,
            min(tmin) as min_temp,
            max(prcp) as precipitation,
            max(snow) as snow,
            max(snwd) as snwd
        from source
        group by station_id, date
    ),

    weather_stats as (
        select
            station_id,
            avg(max_temp) as avg_max_temp,
            stddev(max_temp) as stddev_max_temp,
            avg(min_temp) as avg_min_temp,
            stddev(min_temp) as stddev_min_temp,
            avg(precipitation) as avg_precipitation,
            stddev(precipitation) as stddev_precipitation,
            avg(snow) as avg_snow,
            stddev(snow) as stddev_snow,
            avg(snwd) as avg_snwd,
            stddev(snwd) as stddev_snwd
        from weather_data
        group by station_id
    ),

    extreme_weather_events as (
        select
            w.station_id,
            w.date,
            w.max_temp,
            w.min_temp,
            w.precipitation,
            w.snow,
            w.snwd,
            case
                when w.max_temp > ws.avg_max_temp + (2 * ws.stddev_max_temp)
                then 'extreme high temperature'
                when w.min_temp < ws.avg_min_temp - (2 * ws.stddev_min_temp)
                then 'extreme low temperature'
                when
                    w.precipitation
                    > ws.avg_precipitation + (2 * ws.stddev_precipitation)
                then 'heavy precipitation'
                when w.snow > ws.avg_snow + (2 * ws.stddev_snow)
                    or w.snwd > ws.avg_snwd + (2 * ws.stddev_snwd)
                then 'heavy snowfall'
                else 'normal'
            end as event_type
        from weather_data w
        join weather_stats ws on w.station_id = ws.station_id
    )

select *
from extreme_weather_events
where event_type != 'normal'
order by station_id, date

{% if var("is_test_run", default=true) %}
    limit 500
{% endif %}