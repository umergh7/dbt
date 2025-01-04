{{ config(
    tags=["e-commerce"]
) }}

SELECT
    GENERATE_UUID() AS id,
    u.id AS user_id,
    u.first_name,
    u.last_name,
    u.city,
    COUNT(c.id) AS total_carts,
    SUM(CAST(JSON_EXTRACT_SCALAR(p, '$.quantity') AS INT64)) AS total_products_added,
    AVG(CAST(JSON_EXTRACT_SCALAR(p, '$.quantity') AS INT64)) AS avg_cart_size,
    SUM(CAST(JSON_EXTRACT_SCALAR(p, '$.quantity') AS INT64) * pr.price) AS potential_spending
FROM
    {{ ref('stg_e_commerce_users') }} u
LEFT JOIN
    {{ ref('stg_e_commerce_carts') }} c ON u.id = c.user_id,
    UNNEST(JSON_EXTRACT_ARRAY(c.products)) AS p
LEFT JOIN 
    {{ ref('stg_e_commerce_products') }} pr ON CAST(JSON_EXTRACT_SCALAR(p, '$.productId') AS INT64) = pr.id
GROUP BY 
    u.id, u.first_name, u.last_name, u.city