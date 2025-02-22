{# Estruturas de repeticao #}

{% set lista_1 = ['coluna', 'coluna', 'coluna', 'coluna']%}
    select 
{%- for elx in lista_1 %}
    {{ elx }}_{{ loop.index }},
{%- endfor %}
    from tabela_1;

{# Nested loops #}
{% set dict = {'tabela1': 13, 'tabela2': 4}%} 
{%- for chave,valor in dict.items() %}
    select
    {# valor = [1, 2, 3, 4, 5, 6, 7...]#}
    {% for elemento in range(1, valor + 1) %}
        ${{ elemento }}{% if not loop.last %},{% endif %}
    {%- endfor %}
    from {{ chave }};
{%- endfor %}
{{ dict.items() }}
    

{% set numero_colunas = 12%}
    select 
{%- for _ in range(numero_colunas) %}
    ${{ loop.index }}{% if not loop.last %},{% endif %}
{%- endfor %}
    from tabela_3;

    

{% set lista_1 = ['coluna', 'coluna', 'coluna', 'coluna']%}
    select 
{%- for elx in lista_1 -%}
    {% if loop.last %}
    {{ elx }}_{{ loop.index }}
    {% endif %}
{%- endfor -%}
    from tabela_1;
