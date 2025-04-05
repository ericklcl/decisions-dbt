{% macro create_temp_table(source_name, source_table_name) %}

    select
        {% for col in adapter.get_columns_in_relation(source(source_name, source_table_name)) -%}


            {{ col.name }} as {{ col.name | lower | trim }}_target {%- if not loop.last %}, {% endif %}

        {% endfor -%}
    from {{ source(source_name, source_table_name) }}


{% endmacro %}