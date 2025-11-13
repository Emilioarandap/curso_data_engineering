{{
  config(
    materialized='view'
  )
}}

WITH src_country AS (
    SELECT distinct upper(trim(country)) as country
    FROM {{ ref('stg_sql_server_dbo__addresses') }} 
    ),

country_table AS (
    SELECT 
       {{ dbt_utils.generate_surrogate_key(['country']) }}        as country_id,
        country          as desc_country,                                            
    FROM src_country 
    )

SELECT * FROM country_table
