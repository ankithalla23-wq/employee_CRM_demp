{{
    config(
        materialized='incremental',
        incremental_strategy='merge',
        unique_key='department_id'
    )
}}

with prepared as (

    select
        {{ surrogate_key(['department_id']) }}
            as department_key,

        department_id,
        department_name,
        location,
        manager_employee_id,
        updated_at

    from {{ ref('sl_departments') }}

),

hashed as (

    select
        *,
        {{ row_signature([
            'department_name',
            'location',
            'manager_employee_id'
        ]) }} as row_hash
    from prepared

)

select src.*
from hashed src

{{ incremental_changed('department_id') }}