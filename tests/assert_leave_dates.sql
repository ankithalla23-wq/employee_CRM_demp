select
    leave_id,
    employee_id,
    start_date,
    end_date,
    leave_days

from {{ ref('sl_leaves') }}

where end_date < start_date
   or leave_days <= 0
   or leave_days <> datediff(
       'day',
       start_date,
       end_date
   ) + 1