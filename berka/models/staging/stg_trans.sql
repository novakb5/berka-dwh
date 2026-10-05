with src as (
    select * from {{ source('berka_raw', 'trans') }}
),

parsed as (
    select
        cast(trans_id as integer)          as trans_id,
        cast(account_id as integer)        as account_id,
        {{ yymmdd_to_date('date') }}       as trans_date,
        type,
        nullif(trim(operation), '')        as operation,
        cast(amount as decimal(15, 2))     as amount,
        cast(balance as decimal(15, 2))    as balance,
        nullif(trim(k_symbol), '')         as k_symbol,
        nullif(trim(bank), '')             as bank,
        nullif(trim(account), '')          as account
    from src
)

select
    trans_id,
    account_id,
    trans_date,

    case type
        when 'PRIJEM' then 'credit'
        when 'VYDAJ'  then 'debit'
        when 'VYBER'  then 'debit'
    end                                    as direction,

    case operation
        when 'VKLAD'          then 'cash_deposit'
        when 'PREVOD Z UCTU'  then 'transfer_in'
        when 'VYBER'          then 'cash_withdrawal'
        when 'VYBER KARTOU'   then 'card_withdrawal'
        when 'PREVOD NA UCET' then 'transfer_out'
    end                                    as operation_type,

    amount,
    case when type = 'PRIJEM' then amount else -amount end    as signed_amount,
    balance                                as balance_after,

    case k_symbol
        when 'POJISTNE'    then 'insurance'
        when 'SLUZBY'      then 'statement_fee'
        when 'UROK'        then 'interest'
        when 'SANKC. UROK' then 'penalty_interest'
        when 'SIPO'        then 'household'
        when 'DUCHOD'      then 'pension'
        when 'UVER'        then 'loan_payment'
    end                                    as transaction_purpose,

    bank                                   as counterparty_bank,
    account                                as counterparty_account
from parsed