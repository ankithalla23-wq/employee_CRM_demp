select
    salary_id,
    employee_id,
    base_salary,
    bonus,
    total_compensation

from {{ ref('sl_salaries') }}

where base_salary < 0
   or bonus < 0
   or total_compensation < 0
   or total_compensation <> base_salary + bonus