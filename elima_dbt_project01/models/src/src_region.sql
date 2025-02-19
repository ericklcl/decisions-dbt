with src_region_cte as (
    SELECT
        R_REGIONKEY,
        R_NAME,
        R_COMMENT
    FROM {{ source('SNOWFLAKE_SOURCE', 'REGION') }}
)
select * from src_region_cte