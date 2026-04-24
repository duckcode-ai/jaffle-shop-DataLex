with source as (
    select * from {{ source('jaffle_shop', 'products') }}
),
renamed as (
    select
        cast(sku as varchar) as product_id,
        cast(name as varchar) as product_name,
        cast(type as varchar) as product_type,
        cast(description as varchar) as product_description,
        cast(price as decimal(12, 2)) / 100.0 as product_price,
        type = 'jaffle' as is_food_item,
        type = 'beverage' as is_drink_item
    from source
)
select * from renamed
