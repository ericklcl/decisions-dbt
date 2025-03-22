{% set var1 = adapter.get_relation(
    database='DEMO_DB',
    schema='RAW',
    identifier='SRC_NATION'
)%}


select * from {{ var1 }}
