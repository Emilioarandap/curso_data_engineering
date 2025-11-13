{{
  config(
    materialized='view'
  )
}}

WITH src_shipping_service AS (
    SELECT DISTINCT 
    coalesce(lower(trim(shipping_service)), 'unknown') AS shipping_service_code
    FROM {{ source('sql_server_dbo', 'orders') }} 
    ),

shipping_service_change AS (
   SELECT
   {{ dbt_utils.generate_surrogate_key([
            "shipping_service_code"
        ]) }} AS shipping_service_id,
   shipping_service_code AS desc_shipping_service,
   FROM src_shipping_service 
    )

SELECT * FROM shipping_service_change;

