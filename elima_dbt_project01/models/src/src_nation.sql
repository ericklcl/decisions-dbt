{% set is_valid = '1' %}
{% set execution_datetime = run_started_at %}
SELECT 
'{{ is_valid }}' AS ID,
N_NATIONKEY,
N_NAME,
N_REGIONKEY,
N_COMMENT,
'{{ run_started_at }}' AS EXECUTION_DATETIME
FROM {{ source('SNOWFLAKE_SOURCE', 'NATION') }}