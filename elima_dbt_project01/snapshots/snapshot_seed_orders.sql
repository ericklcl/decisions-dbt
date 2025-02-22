{% snapshot snapshot_seed_orders %}

{{
   config(
       target_database='demo_dev',
       target_schema='snapshots',
       unique_key='order_id',
       strategy='timestamp',
       updated_at='last_updated',
   )
}}

select 
order_id,client_id,order_date,order_status,order_total,order_quantity,last_updated
from {{ ref('seed_orders') }}
{% endsnapshot %}

