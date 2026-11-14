
{{ config(materialized='view') }}

WITH source_employees AS (

    SELECT *
    FROM {{ source('crm_raw', 'employees') }}

),

cleaned_employees AS (

    SELECT
        employee_id::NUMBER(38,0) AS employee_id,
        INITCAP(TRIM(first_name)) AS first_name,
        INITCAP(TRIM(last_name)) AS last_name,
        LOWER(TRIM(email)) AS email,
        UPPER(TRIM(department_id)) AS department_id,
        UPPER(TRIM(job_id)) AS job_id,
        TRY_TO_DATE(hire_date::VARCHAR) AS hire_date,
        UPPER(TRIM(employment_status)) AS employment_status,
        TRY_TO_TIMESTAMP_NTZ(updated_at::VARCHAR) AS updated_at

    FROM source_employees

)

SELECT *
FROM cleaned_employees
