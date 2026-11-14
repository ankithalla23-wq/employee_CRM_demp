{{
    config(
        materialized='incremental',
        incremental_strategy='merge',
        unique_key='job_id'
    )
}}

with prepared as (

    select
        {{ surrogate_key(['job_id']) }}
            as job_key,

        job_id,
        job_title,
        job_grade,
        min_salary,
        max_salary,
        salary_band_width,
        updated_at

    from {{ ref('sl_jobs') }}

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