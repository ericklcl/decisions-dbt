{% set var1 = ref('src_nation')%}

Database: {{ var1.database }}
Schema: {{ var1.schema }}
Identifier: {{ var1.identifier }}