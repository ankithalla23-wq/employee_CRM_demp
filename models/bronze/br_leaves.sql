
{{ config(materialized='view') }}

WITH source_leaves AS (

    SELECT *
    FROM {{ source('crm_raw', 'leaves') }}

),

cleaned_leaves AS (

    SELECT
        UPPER(TRIM(leave_id)) AS leave_id,
        employee_id::NUMBER(38,0) AS employee_id,
        UPPER(TRIM(leave_type)) AS leave_type,
        TRY_TO_DATE(start_date::VARCHAR) AS start_date,
        TRY_TO_DATE(end_date::VARCHAR) AS end_date,
        UPPER(TRIM(approval_status)) AS approval_status,
        TRY_TO_TIMESTAMP_NTZ(updated_at::VARCHAR) AS updated_at

    FROM source_leaves

)

SELECT *
FROM cleaned_leaves
