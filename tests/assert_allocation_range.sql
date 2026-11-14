select
    assignment_id,
    employee_id,
    allocation_pct

from {{ ref('sl_assignments') }}

where allocation_pct < 0
   or allocation_pct > 100
   or allocation_pct is null