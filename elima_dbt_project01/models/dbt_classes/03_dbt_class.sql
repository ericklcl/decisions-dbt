{% set coluna1 = api.Column(column='coluna_01', dtype='varchar') %}

coluna {{ coluna1 }}

nome da coluna: {{ coluna1.column }}

nome da coluna: {{ coluna1.name }}

nome da coluna: {{ coluna1.quoted }}

tipo da coluna: {{ coluna1.dtype }}

tipo da coluna: {{ coluna1.data_type }}

{{ coluna1.is_string() }}

{{ coluna1.is_numeric() }}

{{ coluna1.is_integer() }}

{{ coluna1.is_float() }}
