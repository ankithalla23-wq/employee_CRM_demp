{{
    config(
        materialized='incremental',
        incremental_strategy='merge',
        unique_key='assignment_id'
    )
}}

with prepared as (

    select
        assignment_id,
        employee_id,
        project_id,
        allocation_pct,
        allocation_pct / 100.0
            as allocation_fraction,
        assignment_start_date,
        assignment_end_date,
        updated_at
    from {{ ref('br_assignments') }}

),

hashed as (

    select
        *,
        {{ row_signature([
            'employee_id',
            'project_id',
            'allocation_pct',
            'assignment_start_date',
            'assignment_end_date'
        ]) }} as row_hash
    from prepared

)

select src.*
from hashed src

{{ incremental_changed('assignment_id') }}