{% macro grouped_by_period(table_name, date_column, period='daily')%}

    SELECT
        CASE
            WHEN '{{ period}}' = 'daily' then to_char({{ date_column }},'YYYY-MM-DD')
            WHEN '{{ period}}' = 'monthly' then to_char({{ date_column }},'YYYY-MM')
            WHEN '{{ period}}' = 'yearly' then to_char({{ date_column }},'YYYY')
        END as period_category
        , count(*) as total
    FROM {{ table_name }}
    GROUP BY all
            

{% endmacro %}