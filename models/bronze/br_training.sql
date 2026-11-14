
{{ config(materialized='view') }}

WITH source_training AS (

    SELECT *
    FROM {{ source('crm_raw', 'training') }}

),

cleaned_training AS (

    SELECT
        UPPER(TRIM(training_id)) AS training_id,
        employee_id::NUMBER(38,0) AS employee_id,
        INITCAP(TRIM(course_name)) AS course_name,
        TRY_TO_DATE(training_date::VARCHAR) AS training_date,
        UPPER(TRIM(completion_status)) AS completion_status,
        TRY_TO_NUMBER(score) AS score,
        TRY_TO_TIMESTAMP_NTZ(updated_at::VARCHAR) AS updated_at

    FROM source_training

)

SELECT *
FROM cleaned_training
