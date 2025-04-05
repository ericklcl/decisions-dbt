{% macro dollars_to_million(price)%}
    ({{ price }} / 1000000)
{% endmacro %}