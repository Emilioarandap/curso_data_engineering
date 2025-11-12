{{
  config(
    materialized='view'
  )
}}

WITH src_shipping_service AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'orders') }} 
    ),

shipping_service_change AS (
   SELECT
   {{ dbt_utils.generate_surrogate_key(['shipping_service']) }} AS shipping_service_id,
   shipping_service_id AS desc_shipping_service,
   convert_timezone ('UTC', estimated_delivery_at) AS estimated_delivery_hour,
   convert_timezone ('UTC', delivered_at)  AS delivered_at_hour
   FROM src_shipping_service 
    )

SELECT * FROM shipping_service_change

