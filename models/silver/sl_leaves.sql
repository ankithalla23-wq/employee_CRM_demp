{{
    config(
        materialized='incremental',
        incremental_strategy='merge',
        unique_key='leave_id'
    )
}}

with prepared as (

    select
        leave_id,
        employee_id,
        leave_type,
        start_date,
        end_date,
        approval_status,

        datediff(
            'day',
            start_date,
            end_date
        ) + 1 as leave_days,

        updated_at

    from {{ ref('br_leaves') }}

),

hashed as (

    select
        *,
        {{ row_signature([
            'employee_id',
            'leave_type',
            'start_date',
            'end_date',
            'approval_status'
        ]) }} as row_hash
    from prepared

)

select src.*
from hashed src

{{ incremental_changed('leave_id') }}