select
    salary_id,
    count(*) as current_version_count

from {{ ref('snap_salaries') }}

where dbt_valid_to is null

group by salary_id

having count(*) > 1