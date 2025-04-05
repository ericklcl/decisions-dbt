select
({{ substring_field('customer_name', 8) }}) as customer_substring_name
from {{ ref('stg_customer') }}