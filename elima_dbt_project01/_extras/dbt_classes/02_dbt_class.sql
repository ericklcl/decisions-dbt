{% set var1 = api.Relation.create(database='demo_db', schema='raw', identifier='src_nation')%}

select * from {{ var1 }}