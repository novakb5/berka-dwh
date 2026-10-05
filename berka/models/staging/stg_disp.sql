with src as (
    select * from {{ source('berka_raw', 'disp') }}
)

select
    disp_id,
    client_id,
    account_id,
    lower(type)    as account_role
from src