with orders as (

    select * from {{ ref('stg_jaffle_shop__orders') }}
),

daily as (

    select 
        order_date,
        count(*) as order_count

    from orders
    group by 1
),

compared as (

    select *,
        lag(order_count) over (order by order_date) as previous_day_orders
    from daily
)

select * from compared

