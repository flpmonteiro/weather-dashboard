with

    source as (select * from {{ ref("fct_observations") }}),

    precipitation_daily as (
        select
            station_id,
            date,
            avg(prcp) as avg_precipitation_daily
            from source
            group by station_id, date
    ),

    precipitation_weekly as (
        select
            station_id,
            extract(year from date) as year,
            extract(week from date) as week,
            avg(avg_precipitation_daily) as avg_precipitation_weekly
        from precipitation_daily
        group by station_id, year, week
    ),

    precipitation_monthly as (
        select
            station_id,
            extract(year from date) as year,
            extract(month from date) as month,
            avg(avg_precipitation_daily) as avg_precipitation_monthly
        from precipitation_daily
        group by station_id, year, month
    ),

    precipitation_yearly as (
        select
            station_id,
            extract(year from date) as year,
            avg(avg_precipitation_daily) as avg_precipitation_yearly
        from precipitation_daily
        group by station_id, year
    ),

    precipitation_combined as (
        select
            d.station_id,
            d.date,
            d.avg_precipitation_daily,
            w.avg_precipitation_weekly,
            m.avg_precipitation_monthly,
            y.avg_precipitation_yearly
        from precipitation_daily d
        left join
            precipitation_weekly w
            on d.station_id = w.station_id
            and extract(year from d.date) = w.year
            and extract(week from d.date) = w.week
        left join
            precipitation_monthly m
            on d.station_id = m.station_id
            and extract(year from d.date) = m.year
            and extract(month from d.date) = m.month
        left join
            precipitation_yearly y
            on d.station_id = y.station_id
            and extract(year from d.date) = y.year
    )

select *
from precipitation_combined
order by station_id, date

{% if var("is_test_run", default=true) %}
limit 500
{% endif %}