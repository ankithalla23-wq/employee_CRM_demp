select
    attendance_id,
    employee_id,
    working_hours,
    attendance_status

from {{ ref('sl_attendance') }}

where working_hours < 0
   or working_hours > 24
   or (
       attendance_status in ('ABSENT', 'LEAVE')
       and working_hours <> 0
   )