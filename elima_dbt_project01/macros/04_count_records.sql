{% macro count_table_records(table_name) %}
    select '{{ table_name }}' as table_name, count(*) as record_count from {{ table_name }}
{% endmacro %}