SELECT 
N_NATIONKEY as nation_key,
N_NAME as nation_name,
N_REGIONKEY as region_key,
N_COMMENT as nation_comment
FROM {{ ref('src_nation') }}