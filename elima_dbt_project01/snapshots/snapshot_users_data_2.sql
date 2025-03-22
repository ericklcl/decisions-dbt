{% snapshot snapshot_users_data_2 %}

{{
   config(
       target_database='demo_db',
       target_schema='snapshots',
       unique_key='user_id',
       strategy='check',
        check_cols=['user_age', 'user_name', 'user_email'],
   )
}}
select user_id,user_name,user_age, user_email from {{ ref('users_data_2') }}

{% endsnapshot %}