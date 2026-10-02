with src as (
    select
        client_id,
        district_id,
        cast(birth_number as integer) as bn
    from {{ source('berka_raw', 'client') }}
),

parsed as (
    select
        client_id,
        district_id,
        bn // 10000          as yy,
        (bn // 100) % 100    as mm_raw,
        bn % 100             as dd
    from src
)

select
    client_id,
    district_id,
    case when mm_raw > 50 then 'F' else 'M' end        as gender,
    make_date(
        1900 + yy,
        case when mm_raw > 50 then mm_raw - 50 else mm_raw end,
        dd
    )                                                  as birth_date
from parsed