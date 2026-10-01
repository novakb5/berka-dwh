with src as (
    select * from {{ source('berka_raw', 'account') }}
)

select
    account_id,
    district_id,
    case frequency
        when 'POPLATEK MESICNE'   then 'monthly'
        when 'POPLATEK TYDNE'     then 'weekly'
        when 'POPLATEK PO OBRATU' then 'after_transaction'
    end                                as statement_frequency,
    {{ yymmdd_to_date('date') }}       as opened_date
from src