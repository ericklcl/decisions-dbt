SELECT        
        R_REGIONKEY as region_key,
        R_NAME as region_name,
        R_COMMENT as region_comment
    FROM {{ ref('src_region') }}