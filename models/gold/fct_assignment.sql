{{
    config(
        materialized='incremental',
        incremental_strategy='merge',
        unique_key='assignment_id'
    )
}}

with prepared as (

    select
        a.assignment_id,
        a.employee_id,
        e.employee_key,
        a.project_id,
        p.project_key,
        a.allocation_pct,
        a.allocation_fraction,
        a.assignment_start_date,
        a.assignment_end_date,

        datediff(
            'day',
            a.assignment_start_date,
            a.assignment_end_date
        ) + 1 as assignment_days,

        a.updated_at

    from {{ ref('sl_assignments') }} a

    left join {{ ref('dim_employee') }} e
        on a.employee_id = e.employee_id

    left join {{ ref('dim_project') }} p
        on a.project_id = p.project_id

),

hashed as (

    select
        *,
        {{ row_signature([
            'employee_id',
            'employee_key',
            'project_id',
            'project_key',
            'allocation_pct',
            'allocation_fraction',
            'assignment_start_date',
            'assignment_end_date',
            'assignment_days'
        ]) }} as row_hash
    from prepared

)

select src.*
from hashed src

{{ incremental_changed('assignment_id') }}