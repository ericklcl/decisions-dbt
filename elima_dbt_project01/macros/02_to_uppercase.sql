{% macro to_uppercase(column_name) %}
    upper({{column_name}}::varchar)
{% endmacro %}