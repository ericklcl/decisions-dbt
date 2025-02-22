{% set valor = 15 %}
{% set valor_teste = 10 %}

{% if valor <= valor_teste %}
   O {{ valor }} eh menor o igual a {{ valor_teste }}
{% elif valor >  valor_teste  and valor <= 20 %}
    O valor eh maior que {{ valor_teste }} e menor ou igual a 20
{% else %}
   O valor eh maior que 20 
{% endif %}