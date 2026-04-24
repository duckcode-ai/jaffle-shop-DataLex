with orders as (
    select * from {{ ref('stg_orders') }}
),
order_items as (
    select * from {{ ref('order_items') }}
),
item_summary as (
    select
        order_id,
        count(*) as count_items,
        sum(case when is_food_item then 1 else 0 end) as count_food_items,
        sum(case when is_drink_item then 1 else 0 end) as count_drink_items,
        sum(case when is_food_item then product_price else 0 end) as subtotal_food_items,
        sum(case when is_drink_item then product_price else 0 end) as subtotal_drink_items,
        sum(product_price) as subtotal,
        sum(supply_cost) as order_cost
    from order_items
    group by 1
),
final as (
    select
        orders.order_id,
        orders.customer_id,
        orders.location_id,
        orders.order_total,
        orders.tax_paid,
        orders.ordered_at,
        coalesce(item_summary.count_items, 0) as count_items,
        coalesce(item_summary.count_food_items, 0) as count_food_items,
        coalesce(item_summary.count_drink_items, 0) as count_drink_items,
        coalesce(item_summary.subtotal_food_items, 0) as subtotal_food_items,
        coalesce(item_summary.subtotal_drink_items, 0) as subtotal_drink_items,
        coalesce(item_summary.subtotal, 0) as subtotal,
        coalesce(item_summary.order_cost, 0) as order_cost,
        coalesce(item_summary.count_food_items, 0) > 0 as is_food_order,
        coalesce(item_summary.count_drink_items, 0) > 0 as is_drink_order
    from orders
    left join item_summary on orders.order_id = item_summary.order_id
)
select * from final
