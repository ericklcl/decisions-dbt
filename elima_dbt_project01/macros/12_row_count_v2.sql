{% macro row_count_v2(relation) %}

    {% set query %}
        select count(*) from {{ relation }}
    {% endset %}

    {% if execute %}

        {% set result = run_query(query) %}

        {% set row_count = result.columns[0].values()[0] %}

        {{ return(row_count) }}

    {% endif %}


{% endmacro %}