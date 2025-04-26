{% test valida_column_not_negative(model, column_name) %}

    select * from {{ model }}
    where {{ column_name }} < 0
    limit 1


{% endtest %}