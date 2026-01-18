{{ config(error_if = '>20') }}
select
    customer_id, 
    min(amount) as min_amount
from {{ ref('fct_orders') }}
group by 1
having count(customer_id) > 1 and min_amount < 1