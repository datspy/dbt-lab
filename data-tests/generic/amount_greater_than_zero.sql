{% test amount_greater_than_zero(model, column_name) %}

{{ config(severity='warn') }}

select
    customer_id, 
    min({{ column_name }}) as min_amount
from {{ model }}
group by 1
having min_amount < 1

{% endtest %}