{% macro check_nulls(table_name, field_name) %}

    select 
    '{{ field_name}}' as coluna,
    count(*) as null_count
    from {{ table_name }}
    where {{ field_name }} is null

{% endmacro %}