with
    source as (
        select * from {{ ref("fct_observations") }}
    ),

    snowfall_daily as (
        select
            station_id,
            date,
            avg(snow) as avg_snow_daily,
            avg(snwd) as avg_snwd_daily
        from source
        group by station_id, date
    ),

    snowfall_weekly as (
        select
            station_id,
            extract(year from date) as year,
            extract(week from date) as week,
            avg(avg_snow_daily) as avg_snow_weekly,
            avg(avg_snwd_daily) as avg_snwd_weekly
        from snowfall_daily
        group by station_id, year, week
    ),

    snowfall_monthly as (
        select
            station_id,
            extract(year from date) as year,
            extract(month from date) as month,
            avg(avg_snow_daily) as avg_snow_monthly,
            avg(avg_snwd_daily) as avg_snwd_monthly
        from snowfall_daily
        group by station_id, year, month
    ),

    snowfall_yearly as (
        select
            station_id,
            extract(year from date) as year,
            avg(avg_snow_daily) as avg_snow_yearly,
            avg(avg_snwd_daily) as avg_snwd_yearly
        from snowfall_daily
        group by station_id, year
    ),

    snowfall_combined as (
        select
            d.station_id,
            d.date,
            d.avg_snow_daily,
            d.avg_snwd_daily,
            w.avg_snow_weekly,
            m.avg_snow_monthly,
            y.avg_snow_yearly,
            w.avg_snwd_weekly,
            m.avg_snwd_monthly,
            y.avg_snwd_yearly
        from snowfall_daily d
        left join snowfall_weekly w
            on d.station_id = w.station_id
            and extract(year from d.date) = w.year
            and extract(week from d.date) = w.week
        left join snowfall_monthly m
            on d.station_id = m.station_id
            and extract(year from d.date) = m.year
            and extract(month from d.date) = m.month
        left join snowfall_yearly y
            on d.station_id = y.station_id
            and extract(year from d.date) = y.year
        order by d.station_id, d.date
    )

select *
from snowfall_combined
where coalesce(
            avg_snow_daily,
            avg_snwd_daily,
            avg_snow_weekly,
            avg_snow_monthly,
            avg_snow_yearly,
            avg_snwd_weekly,
            avg_snwd_monthly,
            avg_snwd_yearly
) is not null


{% if var("is_test_run", default=true) %}
    limit 500
{% endif %}
