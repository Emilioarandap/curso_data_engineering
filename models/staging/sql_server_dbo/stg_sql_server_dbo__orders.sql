{{
  config(
    materialized='incremental'
  )
}}

WITH src_orders AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'orders') }} 


{% if is_incremental() %}

	  WHERE _fivetran_synced > (SELECT MAX(date_load) FROM {{ this }} )

{% endif %}
    ),

orders_change AS (
    SELECT
    order_id            as order_id,
    {{ dbt_utils.generate_surrogate_key(['shipping_service']) }} AS shipping_service_id, 
    shipping_cost,
    address_id,
    convert_timezone ('UTC', created_at)        as created_at,
    {{dbt_utils.generate_surrogate_key (['promo_id']) }}  AS promo_id,
    convert_timezone ('UTC', estimated_delivery_at) as estimated_delivery_at,
    order_cost,
    user_id,
    order_total, 
    convert_timezone ('UTC', delivered_at)  AS delivered_at,
    tracking_id,
    status,
    _fivetran_deleted,
    convert_timezone ('UTC', _fivetran_synced)  AS date_load
    FROM src_orders  
    )

SELECT * FROM orders_change