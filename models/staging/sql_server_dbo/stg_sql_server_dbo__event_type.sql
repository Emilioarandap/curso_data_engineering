{{
  config(
    materialized='view'
  )
}}

WITH src_events_type AS (
   select distinct event_type
    from {{ ref('stg_sql_server_dbo__events') }}
    ),

event_type_change AS (
    SELECT
    {{ dbt_utils.generate_surrogate_key(['event_type']) }}   as event_type_id,
    event_type                                               as desc_event_type,

    FROM src_events_type
    )

SELECT * FROM event_type_change