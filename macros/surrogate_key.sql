{% macro surrogate_key(columns) %}

    {{ row_signature(columns) }}

{% endmacro %}