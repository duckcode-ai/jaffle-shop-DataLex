with source as (
    select * from {{ source('jaffle_shop', 'customers') }}
),
renamed as (
    select
        cast(id as integer) as customer_id,
        cast(name as varchar) as customer_name
    from source
)
select * from renamed
