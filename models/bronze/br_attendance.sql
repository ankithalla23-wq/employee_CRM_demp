{{ config(materialized='view') }}
with source_attendance as (
    select * from {{ source('crm_raw', 'attendance') }}
),
cleaned_attendance (
select
    upper(trim(attendance_id)) as attendance_id,
    employee_id::number(38,0) as employee_id,
    try_to_date(attendance_date::varchar) as attendance_date,
    try_to_time(check_in::varchar) as check_in,
    try_to_time(check_out::varchar) as check_out,
    upper(trim(attendance_status)) as attendance_status,
    try_to_timestamp_ntz(updated_at::varchar) as updated_at
from source_attendance
)

select * from cleaned_attendance