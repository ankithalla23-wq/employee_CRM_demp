{{
    config(
        materialized='incremental',
        incremental_strategy='merge',
        unique_key='employee_id'
    )
}}

with prepared as (

    select
        {{ surrogate_key(['e.employee_id']) }}
            as employee_key,

        e.employee_id,
        e.full_name,
        e.email,
        e.department_id,
        d.department_name,
        e.job_id,
        j.job_title,
        j.job_grade,
        e.hire_date,
        e.employment_status,
        e.updated_at

    from {{ ref('sl_employees') }} e

    left join {{ ref('sl_departments') }} d
        on e.department_id = d.department_id

    left join {{ ref('sl_jobs') }} j
        on e.job_id = j.job_id

),

hashed as (

    select
        *,
        {{ row_signature([
            'full_name',
            'email',
            'department_id',
            'department_name',
            'job_id',
            'job_title',
            'job_grade',
            'hire_date',
            'employment_status'
        ]) }} as row_hash
    from prepared

)

select src.*
from hashed src

{{ incremental_changed('employee_id') }}