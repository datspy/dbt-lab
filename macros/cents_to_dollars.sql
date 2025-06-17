{% macro cents_to_dollars(col, decimal_places=2) -%}
    round(1.0 * {{col}}/100, {{decimal_places}})
{% endmacro -%}