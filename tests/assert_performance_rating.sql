select
    review_id,
    rating,
    performance_category

from {{ ref('sl_performance') }}

where rating not between 1 and 5
   or rating is null
   or performance_category <> case
       when rating >= 4 then 'HIGH'
       when rating = 3 then 'MEDIUM'
       else 'LOW'
   end