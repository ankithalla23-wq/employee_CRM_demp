{% macro row_signature(columns) %}

sha2(
    concat_ws(
        '|'
        {% for col in columns %}
        , coalesce(
            to_varchar({{ col }}),
            '<NULL>'
        )
        {% endfor %}
    ),
    256
)

{% endmacro %}