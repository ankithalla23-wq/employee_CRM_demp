{{
    config(
        materialized='incremental',
        incremental_strategy='merge',
        unique_key='review_id'
    )
}}

with prepared as (

    select
        review_id,
        employee_id,
        review_date,
        rating,
        reviewer_employee_id,
        review_status,

        case
            when rating >= 4 then 'HIGH'
            when rating = 3 then 'MEDIUM'
            else 'LOW'
        end as performance_category,

        updated_at

    from {{ ref('br_performance') }}

),

hashed as (

    select
        *,
        {{ row_signature([
            'employee_id',
            'review_date',
            'rating',
            'reviewer_employee_id',
            'review_status'
        ]) }} as row_hash
    from prepared

)

select src.*
from hashed src

{{ incremental_changed('review_id') }}