{#
    This macro implements a pivot in yearly data, keeping only the five core elements
#}

{% macro pivot_element() %}

    max(case when element = 'TMAX' then data_value / 10.0 else null end) as tmax,
    max(case when element = 'TMIN' then data_value / 10.0 else null end) as tmin,
        max(case when element = 'TAVG' then data_value / 10.0 else null end) as tavg,
    max(case when element = 'PRCP' then data_value else null end) as prcp,
    max(case when element = 'SNOW' then data_value else null end) as snow,
    max(case when element = 'snwd' then data_value else null end) as snwd

{% endmacro %}