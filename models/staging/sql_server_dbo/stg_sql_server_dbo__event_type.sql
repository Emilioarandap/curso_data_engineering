{{
  config(
    materialized='view'
  )
}}

WITH src_events_type AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'events') }} 
    ),

event_type_change AS (
    SELECT
    {{ dbt_utils.generate_surrogate_key(['event_type']) }}   as event_type_id,
    event_type_id                                            as desc_event_type,
    convert_timezone ('UTC', _fivetran_synced)    AS date_load
    FROM src_events_type
    )

SELECT * FROM event_type_change