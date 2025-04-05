
select
order_key,
order_date,
{{ dollars_to_million('total_price') }} as total_price
from {{ ref('stg_orders') }}