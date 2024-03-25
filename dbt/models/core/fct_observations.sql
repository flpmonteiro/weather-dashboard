
with unioned as (
{% for year in range(var('start_year'), var('end_year')+1) %}

    (with

    source as (
        select *
        from {{ source("staging", "year_" ~ year) }}
        {% if var('is_test_run', default=true) %}
            limit 500
        {% endif %}
        ),

    renamed as (

        select station_id,
            date(date) as date,
            {{ pivot_element() }}
        from source
        group by station_id, date
        order by station_id, date
    )

    select *
    from renamed
    )

    {{ 'union all' if not loop.last }}

{% endfor %}
)

select *
from unioned

{% if var('is_test_run', default=true) %}
    limit 500
{% endif %}