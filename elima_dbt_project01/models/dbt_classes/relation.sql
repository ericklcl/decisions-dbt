{% set rel1 = ref('stg_nation') %}

Database -> {{ rel1.database }}
Object -> {{ rel1.identifier }}
Schema -> {{ rel1.schema }}

{{ rel1 }}

{% set rel2 = api.Relation.create(database='DEMO_DEV', schema='RAW', identifier='STG_REGION')%}

{{ rel2 }}