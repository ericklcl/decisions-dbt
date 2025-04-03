with source as (
    select * from {{ ref("src_nation") }}
),

renamed as (
    select
        n_nationkey  as nation_key,
        n_name       as nation_name,
        n_regionkey  as region_key,
        n_comment    as comment
    from source
)

select * from renamed