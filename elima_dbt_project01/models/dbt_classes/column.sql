{% set coluna = api.Column(
    column='id',
    dtype='varchar',
)%}

Coluna => {{ coluna }}
Nome da coluna => {{ coluna.column }}
Nome da coluna => {{ coluna.name }}
Tipo de dado => {{ coluna.dtype }}
Tipo de dado 2 {{ coluna.data_type }}
Eh numerico => {{ coluna.is_numeric() }}
Eh numerico => {{ coluna.is_string() }}

