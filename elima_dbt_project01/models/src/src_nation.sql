select
    n_nationkey,
    n_name,
    n_regionkey,
    n_comment
from {{ source('snowflake_source', 'raw_nation') }}