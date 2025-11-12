{{
  config(
    materialized='view'
  )
}}

WITH src_orders_items AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'order_items') }} 
    ),

order_items_change AS (
    SELECT
    {{ dbt_utils.generate_surrogate_key(['order_id', 'product_id']) }}    as order_items_id,
    order_id,
    product_id,
    quantity, 
    convert_timezone ('UTC', _fivetran_synced)  AS date_load
    FROM src_orders_items
    )

SELECT * FROM order_items_change