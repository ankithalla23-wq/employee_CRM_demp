{{ config(materialized='view') }}

WITH source_training as (select * from {{ source('crm_raw', 'training') }}
),

cleaned_training as (

select
    upper(trim(training_id)) as training_id,
    employee_id::number(38,0) as employee_id,
    trim(course_name) as course_name,
    try_to_date(training_date::varchar) as training_date,
    upper(trim(completion_status)) as completion_status,
    try_to_number(score) as score,
    try_to_timestamp_ntz(updated_at::varchar) as updated_at
from source_training

)
 select * from cleaned_training