{{ config(materialized='table') }}

select
    customers.customer_id,
    customers.customer_name,
    customers.customer_type,
    customers.count_lifetime_orders,
    customers.lifetime_spend,
    max(orders.ordered_at) as latest_ordered_at,
    sum(orders.order_total) as modeled_order_total
from {{ ref('dim_customers') }} as customers
left join {{ ref('fct_orders') }} as orders
    on customers.customer_id = orders.customer_id
group by 1, 2, 3, 4, 5
