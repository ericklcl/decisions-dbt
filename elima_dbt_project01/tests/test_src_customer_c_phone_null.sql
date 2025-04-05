select c_phone
from {{ ref('src_customer') }}
where c_phone is null
limit 1