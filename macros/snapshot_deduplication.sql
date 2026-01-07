-- -- PostgreSQL/Snowflake/BigQuery compatible deduplication query
-- {% macro snapshot_deduplication() %}

--     {% set get_delete_records_query %}    

--         WITH sorted_records AS (
--             SELECT 
--                 *,
--                 ROW_NUMBER() OVER (
--                     PARTITION BY id, user_id, order_date, status 
--                     ORDER BY dbt_updated_at ASC
--                 ) AS row_num
--             FROM {{ ref('orders_snapshot') }}
--         ),
--         records_to_delete AS (
--         SELECT * FROM sorted_records WHERE row_num > 1
--         )        
--         DELETE FROM {{ ref('orders_snapshot') }}
--         WHERE (id, user_id, order_date, status, dbt_updated_at) 
--         IN (SELECT id, user_id, order_date, status, dbt_updated_at 
--         FROM records_to_delete);
        
--     {% endset %}

--     {% set get_update_records_query %}    

--         WITH sorted_records AS (
--             SELECT 
--                 *,
--                 ROW_NUMBER() OVER (
--                     PARTITION BY id, user_id, order_date, status 
--                     ORDER BY dbt_updated_at ASC
--                 ) AS row_num
--             FROM {{ ref('orders_snapshot') }}
--         ),
--         records_to_update AS (
--             SELECT * FROM ranked_records WHERE row_num = 1
--         )        
--         UPDATE {{ ref('orders_snapshot') }}
--         SET dbt_valid_to = to_date('9999-12-31')
--         WHERE (id, user_id, order_date, status, dbt_updated_at) 
--         IN (SELECT id, user_id, order_date, status, dbt_updated_at 
--         FROM records_to_update);
        
--     {% endset %}

--     {% do run_query(get_delete_records_query) %} 
--     {% do run_query(get_update_records_query) %} 

-- {% endmacro %}