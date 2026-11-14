{% macro incremental_changed(key_column) %}

{% if is_incremental() %}

where not exists (
    select 1
    from {{ this }} as target
    where target.{{ key_column }}
          = src.{{ key_column }}
      and target.row_hash = src.row_hash
)

{% endif %}

{% endmacro %}