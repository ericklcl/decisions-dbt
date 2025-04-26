{% macro create_backup_table(nome_tabela) %}

    {% set operacao %}
        create or replace table demo_db.raw.backup_{{ nome_tabela }} as
        select * from demo_db.raw.{{ nome_tabela }}
    {% endset %}
    {%
        do run_query(operacao)
    %}

{% endmacro %}