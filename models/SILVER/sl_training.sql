{{
    config(
        materialized='incremental',
        incremental_strategy='merge',
        unique_key='training_id'
    )
}}

with prepared as (

    select
        training_id,
        employee_id,
        course_name,
        training_date,
        completion_status,
        score,

        case
            when completion_status = 'COMPLETED'
            then 1
            else 0
        end as completion_flag,

        updated_at

    from {{ ref('br_training') }}

),

hashed as (

    select
        *,
        {{ row_signature([
            'employee_id',
            'course_name',
            'training_date',
            'completion_status',
            'score'
        ]) }} as row_hash
    from prepared

)

select src.*
from hashed src

{{ incremental_changed('training_id') }}