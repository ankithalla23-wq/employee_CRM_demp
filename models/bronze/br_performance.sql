{{ config(materialized='view') }}

WITH source_performance as (select * from {{ source('crm_raw', 'performance') }} ),

cleaned_performance AS (
select
    upper(trim(review_id)) as review_id,
    employee_id::number(38,0) as employee_id,
    try_to_date(review_date::varchar) as review_date,
    try_to_number(rating) as rating,
    reviewer_employee_id::number(38,0) as reviewer_employee_id,
    upper(trim(review_status)) as review_status,
    try_to_timestamp_ntz(updated_at::varchar) as updated_at
from  source_performance
)

select * from cleaned_performance