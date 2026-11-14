select
    training_id,
    score,
    completion_flag,
    completion_status

from {{ ref('sl_training') }}

where score not between 0 and 100
   or (
       completion_status = 'COMPLETED'
       and completion_flag <> 1
   )
   or (
       completion_status <> 'COMPLETED'
       and completion_flag <> 0
   )