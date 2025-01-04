SELECT 
    id,
    title,
    image,
    price,
    JSON_EXTRACT_SCALAR(rating, '$.rate') AS rating_rate,
    JSON_EXTRACT_SCALAR(rating, '$.count') AS rating_count,
    category,
    description
FROM {{ source ('e_commerce', 'products') }}
