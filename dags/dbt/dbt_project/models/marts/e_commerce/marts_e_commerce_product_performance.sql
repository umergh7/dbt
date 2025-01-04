{{ config(
    tags=["e-commerce"]
) }}

SELECT
    GENERATE_UUID() AS id,
    p.id AS product_id,
    p.title,
    p.category,
    p.price,
    COUNT(c.id) AS total_carts,
    SUM(CAST(JSON_EXTRACT_SCALAR(pc, '$.quantity') AS INT64)) AS total_quantity_sold,
    SUM(CAST(JSON_EXTRACT_SCALAR(pc, '$.quantity') AS INT64) * p.price) AS total_revenue,
    AVG(CAST(p.rating_rate AS FLOAT64)) AS average_rating,  -- Explicitly cast to FLOAT64
    COUNT(DISTINCT c.user_id) AS distinct_users,
    COUNT(c.id) * 100.0 / NULLIF(COUNT(DISTINCT c.user_id), 0) AS conversion_rate,
    SUM(CAST(JSON_EXTRACT_SCALAR(pc, '$.quantity') AS INT64) * p.price) / NULLIF(AVG(CAST(p.rating_rate AS FLOAT64)), 0) AS revenue_per_rating_point,  -- Cast to FLOAT64 here too
    MAX(p.rating_rate) AS max_rating,
    MIN(p.rating_rate) AS min_rating
FROM
    {{ ref('stg_e_commerce_products') }} p
LEFT JOIN
    {{ ref('stg_e_commerce_carts') }} c 
    ON TRUE  -- This is now a cross join. We'll filter by product later.
LEFT JOIN
    UNNEST(JSON_EXTRACT_ARRAY(c.products, '$')) AS pc  -- Unnest the JSON array directly
    ON CAST(JSON_EXTRACT_SCALAR(pc, '$.productId') AS STRING) = CAST(p.id AS STRING)  -- Filter by productId
GROUP BY 
    p.id, p.title, p.category, p.price
