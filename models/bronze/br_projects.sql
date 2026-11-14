{{ config(materialized='view') }}

WITH source_projects AS (select * from {{ source('crm_raw', 'projects') }} ),

cleaned_projects as (

select
    upper(trim(project_id)) as project_id,
    trim(project_name) as project_name,
    trim(client_name) as client_name,
    try_to_date(start_date::varchar) as start_date,
    try_to_date(end_date::varchar) as end_date,
    try_to_decimal(budget,18,2) as budget,
    upper(trim(project_status)) as project_status,
    try_to_timestamp_ntz(updated_at::varchar) as updated_at
from source_projects
)

select * from cleaned_projects