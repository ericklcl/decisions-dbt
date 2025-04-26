{% test valida_range_values(model, column_name, minimo, maximo) %}

    select * from {{ model }}
    where {{ column_name }} >= {{ maximo }}
    or {{ column_name }} <= {{ minimo }}
    limit 1

{% endtest %}