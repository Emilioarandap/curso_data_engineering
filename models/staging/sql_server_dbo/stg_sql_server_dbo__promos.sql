{{
  config(
    materialized='view'
  )
}}

WITH src_promos AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'promos') }}
    ),

promos_change AS (
    SELECT
        MD5(promo_id)                         AS promo_id,
        promo_id                              AS desc_promo,
        discount                              AS discount_dollars,
        status                                AS status_mode,
        _fivetran_deleted                     AS date_deleted,
        convert_timezone ('UTC', _fivetran_synced)    AS date_load
    FROM src_promos
    UNION ALL 
    SELECT  
        MD5('no promo')                       AS promo_id,
        'no promo'                            AS desc_promo,
        0                                     AS discount_dollars,
        'inactive'                            AS status_mode,
        null                                  AS date_deleted,
        convert_timezone ('UTC', current_timestamp(9))  AS date_load

    )

select * FROM promos_change     