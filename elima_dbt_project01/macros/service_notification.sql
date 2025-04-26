{% macro service_notification() %}
    {%
        do run_query("
            call SYSTEM$SEND_EMAIL(
            'elima_notification',
            'ericklcl@gmail.com',
            'Dbt Pipeline OK',
            'O pipeline executou com sucesso.')
        ")
    %}

{% endmacro %}