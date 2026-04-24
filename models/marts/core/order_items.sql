with order_items as (
    select * from {{ ref('stg_order_items') }}
),
orders as (
    select * from {{ ref('stg_orders') }}
),
products as (
    select * from {{ ref('stg_products') }}
),
supplies as (
    select * from {{ ref('stg_supplies') }}
),
supply_costs as (
    select
        product_id,
        sum(supply_cost) as supply_cost
    from supplies
    group by 1
),
joined as (
    select
        order_items.order_item_id,
        order_items.order_id,
        order_items.product_id,
        products.product_name,
        products.product_type,
        products.product_price,
        coalesce(supply_costs.supply_cost, 0) as supply_cost,
        products.is_food_item,
        products.is_drink_item,
        orders.ordered_at
    from order_items
    left join orders on order_items.order_id = orders.order_id
    left join products on order_items.product_id = products.product_id
    left join supply_costs on order_items.product_id = supply_costs.product_id
)
select * from joined
