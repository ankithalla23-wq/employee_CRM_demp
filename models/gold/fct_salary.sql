{{
    config(
        materialized='incremental',
        incremental_strategy='merge',
        unique_key='salary_id'
    )
}}

with prepared as (

    select
        s.salary_id,
        s.employee_id,
        e.employee_key,
        s.effective_date,
        s.base_salary,
        s.bonus,
        s.total_compensation,
        s.currency,
        s.updated_at

    from {{ ref('sl_salaries') }} s

    left join {{ ref('dim_employee') }} e
        on s.employee_id = e.employee_id

),

hashed as (

    select
        *,
        {{ row_signature([
            'employee_id',
            'employee_key',
            'effective_date',
            'base_salary',
            'bonus',
            'total_compensation',
            'currency'
        ]) }} as row_hash
    from prepared

)

select src.*
from hashed src

{{ incremental_changed('salary_id') }}