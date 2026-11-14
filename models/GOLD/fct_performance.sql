{{
    config(
        materialized='incremental',
        incremental_strategy='merge',
        unique_key='review_id'
    )
}}

with prepared as (

    select
        p.review_id,
        p.employee_id,
        e.employee_key,
        p.review_date,
        p.rating,
        p.reviewer_employee_id,
        p.review_status,
        p.performance_category,

        case
            when p.review_status = 'COMPLETED'
             and p.rating >= 4
            then 1
            else 0
        end as high_performer_flag,

        p.updated_at

    from {{ ref('sl_performance') }} p

    left join {{ ref('dim_employee') }} e
        on p.employee_id = e.employee_id

),

hashed as (

    select
        *,
        {{ row_signature([
            'employee_id',
            'employee_key',
            'review_date',
            'rating',
            'reviewer_employee_id',
            'review_status',
            'performance_category',
            'high_performer_flag'
        ]) }} as row_hash
    from prepared

)

select src.*
from hashed src

{{ incremental_changed('review_id') }}