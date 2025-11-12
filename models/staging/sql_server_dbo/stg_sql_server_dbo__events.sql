{{
  config(
    materialized='view'
  )
}}

WITH src_events AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'events') }} 
    ),

events_change AS (
    SELECT
        event_id           as event_id,
        user_id            as user_id,
        product_id         as product_id,
        order_id           as order_id,
        session_id         as session_id,
        convert_timezone('UTC', cast(created_at as timestamp_tz)) as event_created,
        {{ dbt_utils.generate_surrogate_key(['event_type']) }}    as event_type_id,
        nullif(trim(page_url), '')                                as page_url,
        _fivetran_deleted                                         as date_deleted,
        convert_timezone ('UTC', _fivetran_synced)    AS date_load
        
    FROM src_events 
    )

SELECT * FROM events_change