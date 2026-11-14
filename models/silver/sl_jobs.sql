{{
    config(
        materialized='incremental',
        incremental_strategy='merge',
        unique_key='job_id'
    )
}}

with prepared as (

    select
        job_id,
        job_title,
        job_grade,
        min_salary,
        max_salary,
        max_salary - min_salary as salary_band_width,
        updated_at
    from {{ ref('br_jobs') }}

),

hashed as (

    select
        *,
        {{ row_signature([
            'job_title',
            'job_grade',
            'min_salary',
            'max_salary'
        ]) }} as row_hash
    from prepared

)

select src.*
from hashed src

{{ incremental_changed('job_id') }}