select
    employee_id,
    count(*) as current_version_count

from {{ ref('snap_employees') }}

where dbt_valid_to is null

group by employee_id

having count(*) > 1