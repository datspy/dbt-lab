{{
    config(
        materialized='view'
    )
}}

with 

base as (
    select * from {{ ref('fct_orders') }}
),

final as (

    select * from base
    where amount > {{ var('high_order_value') }}
)

select *
from final
