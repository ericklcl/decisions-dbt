{{
  config(
    materialized = 'incremental',
    unique_key = 'order_id'
    )
}}
select * from {{ ref('seed_orders') }}
{% if is_incremental() %}
where last_updated > (select max(last_updated) from {{ this }})
{% endif %}