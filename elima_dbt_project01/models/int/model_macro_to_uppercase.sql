select
{{ to_uppercase('customer_name')}} as customer_name
from {{ ref('stg_customer') }}
