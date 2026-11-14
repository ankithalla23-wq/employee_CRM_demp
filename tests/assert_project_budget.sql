select
    project_id,
    budget,
    start_date,
    end_date

from {{ ref('sl_projects') }}

where budget < 0
   or end_date < start_date