
{{ config(materialized='view') }}

WITH source_salaries AS (

    SELECT *
    FROM {{ source('crm_raw', 'salaries') }}

),

cleaned_salaries AS (

    SELECT
        UPPER(TRIM(salary_id)) AS salary_id,
        employee_id::NUMBER(38,0) AS employee_id,
        TRY_TO_DATE(effective_date::VARCHAR) AS effective_date,

        base_salary::NUMBER(18,2) AS base_salary,
        bonus::NUMBER(18,2) AS bonus,

        UPPER(TRIM(currency)) AS currency,
        TRY_TO_TIMESTAMP_NTZ(updated_at::VARCHAR) AS updated_at

    FROM source_salaries

)

SELECT *
FROM cleaned_salaries
