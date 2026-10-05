with src as (
    select * from {{source('berka_raw', 'card')}}
)

select
    card_id,
    disp_id,
    type as card_type,
    {{ yymmdd_to_date('left(issued, 6)')  }} as issued_date
from src
