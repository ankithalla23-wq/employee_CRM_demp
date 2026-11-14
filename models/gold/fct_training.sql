{{
    config(
        materialized='incremental',
        incremental_strategy='merge',
        unique_key='training_id'
    )
}}

with prepared as (

    select
        t.training_id,
        t.employee_id,
        e.employee_key,
        t.course_name,
        t.training_date,
        t.completion_status,
        t.score,
        t.completion_flag,

        case
            when t.completion_status = 'COMPLETED'
             and t.score >= 80
            then 1
            else 0
        end as certification_eligible_flag,

        t.updated_at

    from {{ ref('sl_training') }} t

    left join {{ ref('dim_employee') }} e
        on t.employee_id = e.employee_id

),

hashed as (

    select
        *,
        {{ row_signature([
            'employee_id',
            'employee_key',
            'course_name',
            'training_date',
            'completion_status',
            'score',
            'completion_flag',
            'certification_eligible_flag'
        ]) }} as row_hash
    from prepared

)

select src.*
from hashed src

{{ incremental_changed('training_id') }}