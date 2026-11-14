select
    job_id,
    min_salary,
    max_salary

from {{ ref('sl_jobs') }}

where min_salary < 0
   or max_salary < min_salary