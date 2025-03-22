{% set relation_01 = adapter.get_relation(
    database='DEMO_DB',
    schema='RAW',
    identifier='SRC_NATION'
)%}

{%
    set colunas = adapter.get_columns_in_relation(relation_01)
%}


SELECT
{% for coluna in colunas -%}
    {{ coluna.name }} {{ coluna.data_type }}{% if not loop.last %},{% endif %}
{% endfor -%}
FROM {{ relation_01 }}	




