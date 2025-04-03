with source as (
    select * from {{ ref("src_region") }}
),

renamed as (
    select
        r_regionkey as region_key,
        r_name      as region_name,
        r_comment   as comment
    from source
)

select * from renamed