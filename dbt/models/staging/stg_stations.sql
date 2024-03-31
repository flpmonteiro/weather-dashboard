with 

source as (

    select * from {{ source('staging', 'stations') }}

),

renamed as (

    select
        id,
        left(id, 2) as country_code,
        latitude,
        longitude

    from source

)

select * from renamed

{% if var("is_test_run", default=true) %}
limit 500
{% endif %}