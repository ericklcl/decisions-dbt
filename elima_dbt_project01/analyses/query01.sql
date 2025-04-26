select region_id, count(*) as total
from {{ ref('stg_region') }}
group by region_id
having count(*) > 1