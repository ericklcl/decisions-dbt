{% set var1 = 50 %}

{% set var2 = var1 / 2 %}


{{ var2 }}


{% set var3 = ['hello', 'hi', 'awesome'] %}

Lista antes: {{ var3 }}

{% set var3 = var3 + ['got it'] %}

Lista depois: {{ var3 }}


{% set var4 = {'key1':'value1', 'key2': 3} %}

{{ var4['key1'] }}

{{ var4.values()}}


{% set var6 %}

SELECT * FROM TABELA1 WHERE DATA = 'ABC'
HELLO, WHERE ARE YOU?

{% endset %}

{{ var6 }}

SELECT 
{{ var6 }}
FROM TABELA2

Target name: {{ target.name }}

Target user: {{ target.user }}
Target database: {{ target.database }}

DBT Version: {{ dbt_version }}

Execution time: {{ run_started_at }}

{{ this }}
