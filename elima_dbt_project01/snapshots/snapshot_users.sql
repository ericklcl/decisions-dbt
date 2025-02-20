{% snapshot snapshot_users_data %}

{{
   config(
       target_database='demo_dev',
       target_schema='snapshots',
       unique_key='id',
       strategy='timestamp',
       updated_at='updated_at',
   )
}}
select id,name,age,updated_at from {{ ref('users_data')}}

{% endsnapshot %}