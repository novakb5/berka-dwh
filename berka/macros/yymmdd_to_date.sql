   {% macro yymmdd_to_date(col) %}
       make_date(
           1900 + cast({{ col }} as integer) // 10000,
           (cast({{ col }} as integer) // 100) % 100,
           cast({{ col }} as integer) % 100
       )
   {% endmacro %}