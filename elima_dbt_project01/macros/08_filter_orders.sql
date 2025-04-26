{% macro filter_orders(start_date, end_date)%}

select * from {{ source('snowflake_source', 'raw_orders') }} 
where o_orderdate >= '{{ start_date }}' and o_orderdate <= '{{ end_date }}'

{% endmacro %}