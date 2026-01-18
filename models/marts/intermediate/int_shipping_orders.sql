{{
    config(
        materialized='view'
    )
}}

with

base as (
    select * from {{ ref('int_customer_transactions') }}
),

final as (
    select *
    from base
    where order_status=  "{{ var('order_status') }}"
    order by order_id
)

select * from final