with

    source as (select * from {{ source("staging", "year_2024") }}),

    renamed as (

        select
            station_id,
            date(date) as date,
            {{ pivot_element() }}
        from source
        group by station_id, date
        order by station_id, date
    )

select * from renamed

limit 100