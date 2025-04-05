{% set coluna = 'customer_name'%}


{{ check_nulls(ref('stg_customer'), coluna)}}