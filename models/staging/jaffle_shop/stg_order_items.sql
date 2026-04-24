with source as (
    select * from {{ source('jaffle_shop', 'items') }}
),
renamed as (
    select
        cast(id as integer) as order_item_id,
        cast(order_id as integer) as order_id,
        cast(sku as varchar) as product_id
    from source
)
select * from renamed
