with customers as (
    select * from {{ ref('stg_customers') }}
),
orders as (
    select * from {{ ref('fct_orders') }}
),
order_summary as (
    select
        customer_id,
        count(distinct order_id) as count_lifetime_orders,
        min(ordered_at) as first_ordered_at,
        max(ordered_at) as last_ordered_at,
        sum(subtotal) as lifetime_spend_pretax,
        sum(order_total) as lifetime_spend,
        count(distinct order_id) > 1 as is_repeat_buyer
    from orders
    group by 1
),
final as (
    select
        customers.customer_id,
        customers.customer_name,
        coalesce(order_summary.count_lifetime_orders, 0) as count_lifetime_orders,
        order_summary.first_ordered_at,
        order_summary.last_ordered_at,
        coalesce(order_summary.lifetime_spend_pretax, 0) as lifetime_spend_pretax,
        coalesce(order_summary.lifetime_spend, 0) as lifetime_spend,
        case
            when coalesce(order_summary.is_repeat_buyer, false) then 'returning'
            else 'new'
        end as customer_type
    from customers
    left join order_summary on customers.customer_id = order_summary.customer_id
)
select * from final
