{{
    config(
        materialized='incremental',
        incremental_strategy='merge',
        unique_key='project_id'
    )
}}

with prepared as (

    select
        {{ surrogate_key(['project_id']) }}
            as project_key,

        project_id,
        project_name,
        client_name,
        start_date,
        end_date,
        budget,
        project_status,
        project_duration_days,
        updated_at

    from {{ ref('sl_projects') }}

),

hashed as (

    select
        *,
        {{ row_signature([
            'project_name',
            'client_name',
            'start_date',
            'end_date',
            'budget',
            'project_status'
        ]) }} as row_hash
    from prepared

)

select src.*
from hashed src

{{ incremental_changed('project_id') }}