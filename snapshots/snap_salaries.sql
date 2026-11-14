{% snapshot snap_salaries %}

{{
    config(
        target_schema='HISTORY',
        unique_key='salary_id',
        strategy='check',
        check_cols=['row_hash'],
        invalidate_hard_deletes=True
    )
}}

select
    salary_id,
    employee_id,
    effective_date,
    base_salary,
    bonus,
    total_compensation,
    currency,
    updated_at,
    row_hash

from {{ ref('sl_salaries') }}

{% endsnapshot %}