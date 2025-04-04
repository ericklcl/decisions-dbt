{% set var1 = 'john' %}

{{ var1 | upper }}

{{ var1 | upper | title }}

{{ var1 | upper | title | replace('J', 'K')}}

{{ var1 | upper | title | replace('J', 'K') | length }}

{% set col = 'coluna     ' %}
SELECT
{{col | upper}},
{{col | upper | trim}},
from table

{% set var = ['hello', 'hi', 'awesome']%}
{% for elemento in range(1,var | length + 1)%}
    O {{ loop.index}}º elemento é {{ var[loop.index0] }}
{% endfor %}

select {{ var }} from tabela

select {{ var | join(',')}} from tabela

{% set var4 = {'key1':'value1', 'key2': 3} %}

select {{ var4.keys() | join(', ')}} 
from tabela


{{ ['hello', 'hi', 'awesome'] | last }}


{{ 3.1453456 | round(2)}}

{{ 3.1453456 | int }}

{{ -3.1453456 | abs }}

{{ 3 | float }}

{{ 3.1453456 | round(2) | float }}

{{ 3.1453456 | round(2) | float | abs }}


{% set var = [3, 2, 1, 10, 4]%}

select
{% for col in var | sort(true) %} {# sort - decrescente #}
    ${{ col }}{% if not loop.last %},{% endif %}
{% endfor %}
from tabela_x