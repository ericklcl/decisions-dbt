{{
  config(
    materialized = 'table',
    )
}}
{{ filter_orders('1995-01-01', '1997-01-01') }}