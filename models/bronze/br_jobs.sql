
{{ config(materialized='view') }}

WITH source_jobs AS (

    SELECT *
    FROM {{ source('crm_raw', 'jobs') }}

),

cleaned_jobs AS (

    SELECT
        UPPER(TRIM(job_id)) AS job_id,
        INITCAP(TRIM(job_title)) AS job_title,
        UPPER(TRIM(job_grade)) AS job_grade,
        TRY_TO_DECIMAL(min_salary, 18, 2) AS min_salary,
        TRY_TO_DECIMAL(max_salary, 18, 2) AS max_salary,
        TRY_TO_TIMESTAMP_NTZ(updated_at::VARCHAR) AS updated_at

    FROM source_jobs

)

SELECT *
FROM cleaned_jobs
