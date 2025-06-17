-- Import CTEs

with

orders as (

    select * from {{ ref('int_orders') }}

),

customers as (

    select * from {{ ref('stg_jaffle_shop__customers') }}

),

-- Logical CTEs

customer_orders as (

    select

        orders.*,
        customers.full_name,
        customers.surname,
        customers.givenname, 

        min(orders.order_date) over(partition by orders.customer_id) as first_order_date,
        min(orders.valid_order_date) over(partition by orders.customer_id) as first_non_returned_order_date,
        max(orders.valid_order_date) over(partition by orders.customer_id) as most_recent_non_returned_order_date,
        count(*) over(partition by orders.customer_id) as order_count,       
        sum(nvl2(orders.valid_order_date,1,0)) 
            over(partition by orders.customer_id) as non_returned_order_count,
        sum(nvl2(orders.valid_order_date,orders.order_value_dollars,0)) 
            over(partition by orders.customer_id) as total_lifetime_value,
        (total_lifetime_value / non_returned_order_count) as avg_non_returned_order_value        

    from orders
    inner join customers
    on orders.customer_id=customers.customer_id

),

-- Final CTE

final as (

    select 
        order_id,
        customer_id,
        surname,
        givenname,
        first_order_date,
        order_count,
        total_lifetime_value,
        order_value_dollars,
        order_status,
        payment_status

    from customer_orders
    order by order_id
)

-- Simple Select Statement

select * from final