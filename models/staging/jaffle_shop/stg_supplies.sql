with source as (
    select * from {{ source('jaffle_shop', 'supplies') }}
),
renamed as (
    select
        md5(cast(id as varchar) || '-' || cast(sku as varchar)) as supply_uuid,
        cast(id as integer) as supply_id,
        cast(sku as varchar) as product_id,
        cast(name as varchar) as supply_name,
        cast(cost as decimal(12, 2)) / 100.0 as supply_cost,
        cast(perishable as boolean) as is_perishable_supply
    from source
)
select * from renamed
