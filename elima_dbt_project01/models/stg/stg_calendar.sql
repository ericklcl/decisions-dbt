select year, date
from {{ ref('calendar') }}