{{
  config(
    materialized='view'
  )
}}

WITH src_addresses AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'addresses') }} 
    ),

addresses_change AS (
    SELECT
        address_id,
        cast(zipcode AS INT)                                   AS zipcode,
        {{ dbt_utils.generate_surrogate_key(['country']) }}    AS country_id,    
        ltrim(address, ' 0123456789-')                         AS street_name,                                        
        address                                                AS address,       
       {{ dbt_utils.generate_surrogate_key(['state']) }}       AS state_id, 
        convert_timezone ('UTC', _fivetran_synced)             AS date_load
        
    FROM src_addresses  
    )

SELECT * FROM addresses_change