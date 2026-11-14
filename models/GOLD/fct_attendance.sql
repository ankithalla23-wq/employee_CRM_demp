{{
    config(
        materialized='incremental',
        incremental_strategy='merge',
        unique_key='attendance_id'
    )
}}

with prepared as (

    select
        a.attendance_id,
        a.employee_id,
        e.employee_key,
        a.attendance_date,
        a.attendance_status,
        a.check_in,
        a.check_out,
        a.working_hours,

        case
            when a.attendance_status = 'PRESENT'
            then 1
            else 0
        end as present_flag,

        a.updated_at

    from {{ ref('sl_attendance') }} a

    left join {{ ref('dim_employee') }} e
        on a.employee_id = e.employee_id

),

hashed as (

    select
        *,
        {{ row_signature([
            'employee_id',
            'employee_key',
            'attendance_date',
            'attendance_status',
            'check_in',
            'check_out',
            'working_hours',
            'present_flag'
        ]) }} as row_hash
    from prepared

)

select src.*
from hashed src

{{ incremental_changed('attendance_id') }}