with 
base as (
    select * from {{ ref('fct_orders') }}
),

final as (

    select customer_id, count(1) as orders, sum(amount) as total_order_amount
    from base
    group by 1
    order by 1

)

select * from final