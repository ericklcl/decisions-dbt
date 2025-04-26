{% macro row_count_v1(relation) %}

    {% set query %}
        select count(*) from {{ relation }}
    {% endset %}

    {% set result = run_query(query) %}

    {% set row_count = result.columns[0].values()[0] %}

    {{ return(row_count) }}


{% endmacro %}