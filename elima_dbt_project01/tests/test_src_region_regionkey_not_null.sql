with not_nulls as 
(
    select * from {{ ref('src_region') }}
    where r_regionkey is null
),
filtered_nulls as (
    select count(*) as total 
    from not_nulls
)
select * from filtered_nulls
where total > 10
limit 1