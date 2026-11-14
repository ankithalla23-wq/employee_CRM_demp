
{{ config(materialized='view') }}

WITH source_assignments AS (

    SELECT *
    FROM {{ source('crm_raw', 'assignments') }}

),

cleaned_assignments AS (

    SELECT
        UPPER(TRIM(assignment_id)) AS assignment_id,
        employee_id::NUMBER(38,0) AS employee_id,
        UPPER(TRIM(project_id)) AS project_id,
        TRY_TO_DECIMAL(allocation_pct::VARCHAR, 5, 2) AS allocation_pct,
        TRY_TO_DATE(assignment_start_date::VARCHAR) AS assignment_start_date,
        TRY_TO_DATE(assignment_end_date::VARCHAR) AS assignment_end_date,
        TRY_TO_TIMESTAMP_NTZ(updated_at::VARCHAR) AS updated_at

    FROM source_assignments

)

SELECT *
FROM cleaned_assignments
