{{
    config(
        materialized='incremental',
        incremental_strategy='merge',
        unique_key='leave_id'
    )
}}

with prepared as (

    select
        l.leave_id,
        l.employee_id,
        e.employee_key,
        l.leave_type,
        l.start_date,
        l.end_date,
        l.approval_status,
        l.leave_days,

        case
            when l.approval_status = 'APPROVED'
            then l.leave_days
            else 0
        end as approved_leave_days,

        l.updated_at

    from {{ ref('sl_leaves') }} l

    left join {{ ref('dim_employee') }} e
        on l.employee_id = e.employee_id

),

hashed as (

    select
        *,
        {{ row_signature([
            'employee_id',
            'employee_key',
            'leave_type',
            'start_date',
            'end_date',
            'approval_status',
            'leave_days',
            'approved_leave_days'
        ]) }} as row_hash
    from prepared

)

select src.*
from hashed src

{{ incremental_changed('leave_id') }}