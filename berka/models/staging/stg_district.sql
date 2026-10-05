with src as (
    select * from {{ source('berka_raw', 'district') }}
)

select
    A1                          as district_id,
    A2                          as district_name,
    A3                          as region,
    A4                          as population,
    A5                          as municipalities_lt_500,
    A6                          as municipalities_500_1999,
    A7                          as municipalities_2000_9999,
    A8                          as municipalities_gte_10000,
    A9                          as cities_count,
    A10                         as urban_ratio_pct,
    A11                         as avg_salary,
    try_cast(A12 as double)     as unemployment_rate_1995,
    A13                         as unemployment_rate_1996,
    A14                         as entrepreneurs_per_1000,
    try_cast(A15 as integer)    as crimes_1995,
    A16                         as crimes_1996
from src