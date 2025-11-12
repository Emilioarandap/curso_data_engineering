{{
  config(
    materialized='view'
  )
}}

WITH src_state AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'addresses') }} 
    ),

state_table AS (
    SELECT
       {{ dbt_utils.generate_surrogate_key(['state']) }}     AS state_id,
        state_id          AS desc_state,  
        country,    
        convert_timezone ('UTC', _fivetran_synced)    AS date_load                                        
    FROM src_state 
    )

SELECT * FROM state_table