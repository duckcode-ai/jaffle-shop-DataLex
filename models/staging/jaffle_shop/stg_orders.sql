with source as (
    select * from {{ source('jaffle_shop', 'orders') }}
),
renamed as (
    select
        cast(id as integer) as order_id,
        cast(store_id as integer) as location_id,
        cast(customer as integer) as customer_id,
        cast(order_total as decimal(12, 2)) / 100.0 as order_total,
        cast(tax_paid as decimal(12, 2)) / 100.0 as tax_paid,
        cast(ordered_at as timestamp) as ordered_at
    from source
)
select * from renamed
