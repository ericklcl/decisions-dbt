select
    r_regionkey,
    r_name,
    r_comment
from {{ source('snowflake_source', 'raw_region') }}