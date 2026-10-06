with days as (
    select range::date as date_day
    from range(
        date '{{ var("start_date") }}',
        date '{{ var("end_date") }}',
        interval 1 day
    )
)

select
    cast(strftime(date_day, '%Y%m%d') as integer)   as date_key,
    date_day,

    year(date_day)                                  as year,
    quarter(date_day)                               as quarter,
    month(date_day)                                 as month,
    monthname(date_day)                             as month_name,
    strftime(date_day, '%Y-%m')                     as year_month,
    day(date_day)                                   as day_of_month,

    isodow(date_day)                                as day_of_week,
    dayname(date_day)                               as day_name,
    isodow(date_day) in (6, 7)                      as is_weekend,

    date_trunc('month', date_day)::date             as month_start,
    last_day(date_day)                              as month_end,
    date_day = last_day(date_day)                   as is_month_end
from days