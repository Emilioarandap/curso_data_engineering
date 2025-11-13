{{
  config(
    materialized='view'
  )
}}

WITH src_state AS (
    select distinct trim(state) as state
    from {{ ref('stg_sql_server_dbo__addresses') }}
),,

state_table AS (
    SELECT
       {{ dbt_utils.generate_surrogate_key(['state']) }}     AS state_id,
        state         AS desc_state,  
        country,                                           
    FROM src_state 
    )

SELECT * FROM state_table