{% snapshot snap_employees %}

{{
    config(
        target_schema='HISTORY',
        unique_key='employee_id',
        strategy='check',
        check_cols=['row_hash'],
        invalidate_hard_deletes=True
    )
}}

select
    employee_id,
    first_name,
    last_name,
    full_name,
    email,
    department_id,
    job_id,
    hire_date,
    employment_status,
    updated_at,
    row_hash

from {{ ref('sl_employees') }}

{% endsnapshot %}