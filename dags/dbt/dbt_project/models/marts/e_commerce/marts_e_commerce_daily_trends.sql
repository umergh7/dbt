{{ config(
    tags=["e-commerce"]
) }}


SELECT 
    DATE(c.date) AS transaction_date,
    SUM(CASE 
            WHEN pc.quantity IS NOT NULL 
            AND pc.quantity != '' 
            THEN CAST(pc.quantity AS INT64) * p.price
            ELSE 0 
        END) AS daily_revenue,
    SUM(CASE 
            WHEN pc.quantity IS NOT NULL 
            AND pc.quantity != '' 
            THEN CAST(pc.quantity AS INT64)
            ELSE 0 
        END) AS daily_quantity_sold,
    COUNT(DISTINCT c.user_id) AS daily_active_users
FROM 
    {{ ref('stg_e_commerce_carts') }} c
LEFT JOIN 
    UNNEST(JSON_EXTRACT_ARRAY(c.products, '$')) AS product_json  -- Extract array of JSON objects
LEFT JOIN 
    {{ ref('stg_e_commerce_products') }} p 
    ON CAST(JSON_EXTRACT_SCALAR(product_json, '$.productId') AS INT64) = p.id  -- Join on productId after extracting from JSON
LEFT JOIN 
    UNNEST([STRUCT(
        CAST(JSON_EXTRACT_SCALAR(product_json, '$.productId') AS STRING) AS productId,
        CAST(JSON_EXTRACT_SCALAR(product_json, '$.quantity') AS STRING) AS quantity
    )]) AS pc  -- Convert each JSON object into a STRUCT for further processing
GROUP BY 
    transaction_date
