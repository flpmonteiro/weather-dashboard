{{ config(materialized="table") }}

with
    stations as (select * from {{ ref("stg_stations") }}),

    countries as (select * from {{ ref("stg_countries") }}),

    joined as (
        select *
        from stations
        left join countries on stations.country_code = countries.code
    )

select id as station_id, country, latitude, longitude
from joined
