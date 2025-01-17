WITH Base AS (
SELECT
    customer,
    product,
    quantity,
    'Return' AS transaction_type,
    timestamp
FROM {{ ref('stg_spectra_purchases') }}
WHERE product != ''

UNION ALL

SELECT
    customer,
    product_name AS product,
    quantity,
    'Rental' AS transaction_type,
    timestamp
FROM {{ ref('stg_spectra_sales') }}
WHERE product_name != ''
)

SELECT
GENERATE_UUID() AS id,
customer,
b.product,
p.category as category,
quantity,
transaction_type,
timestamp
from base as b
left join {{ ref('stg_spectra_products') }} as p
on b.product = p.product
order by timestamp 
