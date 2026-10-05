with src as (
    select * from {{ source('berka_raw', 'loan') }}
)

select
    loan_id,
    account_id,
    {{ yymmdd_to_date('date') }}   as loan_date,
    amount                         as loan_amount,
    duration                       as duration_months,
    payments                       as monthly_payment,

    case status
        when 'A' then 'finished_ok'
        when 'B' then 'finished_unpaid'
        when 'C' then 'running_ok'
        when 'D' then 'running_late'
    end                            as loan_status,

    case
        when status in ('A', 'B') then 'finished'
        when status in ('C', 'D') then 'running'
    end                            as loan_lifecycle,

    status in ('B', 'D')           as is_problematic
from src