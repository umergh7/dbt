With base as (
SELECT *,
ROW_NUMBER() OVER (PARTITION BY product ORDER BY timestamp) as latest
 FROM {{ ref('stg_spectra_purchases') }}
where product != ''
),


initial_stock  AS (
SELECT product, quantity as initial_stock from base 
where latest = 1
),

purchases_summary AS (
    SELECT
        product AS product_name,
        product_barcode,
        SUM(quantity) AS total_returned
    FROM {{ ref('stg_spectra_purchases') }}
    WHERE product != ''
    GROUP BY product, product_barcode
),

sales_summary AS (
    SELECT
        product_name,
        product_barcode,
        SUM(quantity) AS total_rented
    FROM {{ ref('stg_spectra_sales') }}
    WHERE product_name != ''
    GROUP BY product_name, product_barcode
),

stock_calculation AS (
    SELECT
        p.product_name,
        p.product_barcode,
        p.total_returned,
        COALESCE(s.total_rented, 0) AS total_rented, -- Handle cases where no sales exist
        p.total_returned - COALESCE(s.total_rented, 0) AS current_stock
    FROM purchases_summary p
    LEFT JOIN sales_summary s
    ON p.product_barcode = s.product_barcode
)

SELECT 
    GENERATE_UUID() AS id,
    product_name,
    s.product_barcode,
    p.category as product_category,
    total_returned,
    total_rented,
    s.current_stock,
    p.min_order,
    CASE WHEN
        s.current_stock <= p.min_order THEN TRUE ELSE FALSE END AS low_stock_flag
FROM stock_calculation as s 
left join {{ ref('stg_spectra_products') }} as p
on s.product_name = p.product
