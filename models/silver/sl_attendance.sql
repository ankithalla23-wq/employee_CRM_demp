{{
    config(
        materialized='incremental',
        incremental_strategy='merge',
        unique_key='attendance_id'
    )
}}

with prepared as (

    select
        attendance_id,
        employee_id,
        attendance_date,
        check_in,
        check_out,
        attendance_status,

        case
            when attendance_status = 'PRESENT'
             and check_in is not null
             and check_out is not null
            then round(
                datediff(
                    'minute',
                    check_in,
                    check_out
                ) / 60.0,
                2
            )
            else 0
        end as working_hours,

        updated_at

    from {{ ref('br_attendance') }}

),

hashed as (

    select
        *,
        {{ row_signature([
            'employee_id',
            'attendance_date',
            'check_in',
            'check_out',
            'attendance_status'
        ]) }} as row_hash
    from prepared

)

select src.*
from hashed src

{{ incremental_changed('attendance_id') }}