SELECT
    id,
    userid AS user_id,
    products, 
    date 
FROM {{ source ('e_commerce', 'carts') }}
