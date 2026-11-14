
{{ config(materialized='view') }}

WITH source_departments AS (

    SELECT *
    FROM {{ source('crm_raw', 'departments') }}

),

cleaned_departments AS (

    SELECT
        UPPER(TRIM(department_id)) AS department_id,
        INITCAP(TRIM(department_name)) AS department_name,
        INITCAP(TRIM(location)) AS location,
        manager_employee_id::NUMBER(38,0) AS manager_employee_id,
        TRY_TO_TIMESTAMP_NTZ(updated_at::VARCHAR) AS updated_at

    FROM source_departments

)

SELECT *
FROM cleaned_departments
