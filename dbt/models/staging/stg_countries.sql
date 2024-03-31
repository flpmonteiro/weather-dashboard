with 

source as (

    select * from {{ source('staging', 'countries') }}

),

renamed as (

    select
        code,
        country

    from source

)

select * from renamed
