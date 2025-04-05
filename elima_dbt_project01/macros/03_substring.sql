{% macro substring_field(field_name, num_char = 4) %}
    substr({{ field_name }}, charindex('#', {{field_name}}, 1) + 1, {{ num_char }})
{% endmacro %}