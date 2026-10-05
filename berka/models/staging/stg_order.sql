with src as (
    select * from {{ source('berka_raw', 'order') }}
),

parsed as (
    select
        cast(order_id as integer)          as order_id,
        cast(account_id as integer)        as account_id,
        bank_to,
        account_to,
        cast(amount as decimal(12, 2))     as amount,
        nullif(trim(k_symbol), '')         as k_symbol
    from src
)

select
    order_id,
    account_id,
    bank_to                            as recipient_bank,
    account_to                         as recipient_account,
    amount                             as order_amount,
    case k_symbol
        when 'POJISTNE' then 'insurance'
        when 'SIPO'     then 'household'
        when 'LEASING'  then 'leasing'
        when 'UVER'     then 'loan_payment'
    end                                as payment_purpose
from parsed