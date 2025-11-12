{{
  config(
    materialized='view'
  )
}}

WITH src_country AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'addresses') }} 
    ),

country_table AS (
    SELECT 
       {{ dbt_utils.generate_surrogate_key(['country']) }}        as country_id,
        country_id           as desc_country,            
        convert_timezone ('UTC', _fivetran_synced) AS date_load                                  
    FROM src_country 
    )

SELECT * FROM country_table
