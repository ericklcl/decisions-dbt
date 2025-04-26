{% macro nation_table() %}

    {%
        set resultado = run_query("select * from demo_db.raw.src_nation")
    %}

    {%
        do resultado.print_table()
    %}

{% endmacro %}