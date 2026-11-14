{{
    config(
        materialized='incremental',
        incremental_strategy='merge',
        unique_key='employee_id'
    )
}}

with prepared as (

    select
        employee_id,
        first_name,
        last_name,
        concat_ws(' ', first_name, last_name)
            as full_name,
        email,
        department_id,
        job_id,
        hire_date,
        employment_status,
        updated_at
    from {{ ref('br_employees') }}

),

hashed as (

    select
        *,
        {{ row_signature([
            'first_name',
            'last_name',
            'email',
            'department_id',
            'job_id',
            'hire_date',
            'employment_status'
        ]) }} as row_hash
    from prepared

)

select src.*
from hashed src

{{ incremental_changed('employee_id') }}