{{
  config(
    materialized='view'
  )
}}

WITH src_products AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'products') }} 
    ),

products_change AS (
    SELECT
        product_id,                            
        CAST(price AS DECIMAL(12,2))         AS product_price,
        name                                  AS product_name,
        cast(inventory AS INT)                AS inventory,          
        _fivetran_deleted                     AS date_deleted,
        convert_timezone ('UTC', _fivetran_synced)    AS date_load

    FROM src_products   
    )

SELECT * FROM products_change