{{
    config(
        materialized='incremental',
        incremental_strategy='merge',
        unique_key='salary_id'
    )
}}

with prepared as (

    select
        salary_id,
        employee_id,
        effective_date,
        base_salary,
        coalesce(bonus, 0) as bonus,
        base_salary + coalesce(bonus, 0)
            as total_compensation,
        currency,
        updated_at
    from {{ ref('br_salaries') }}

),

hashed as (

    select
        *,
        {{ row_signature([
            'employee_id',
            'effective_date',
            'base_salary',
            'bonus',
            'currency'
        ]) }} as row_hash
    from prepared

)

select src.*
from hashed src

{{ incremental_changed('salary_id') }}