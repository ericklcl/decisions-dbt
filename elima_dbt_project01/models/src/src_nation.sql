{% set is_valid = '1' %}
SELECT 
'{{ is_valid }}' AS ID,
N_NATIONKEY,
N_NAME,
N_REGIONKEY,
N_COMMENT
FROM {{ source('SNOWFLAKE_SOURCE', 'NATION') }}