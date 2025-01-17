WITH daily_summary AS (
    SELECT
        DATE(timestamp) AS transaction_date,
        category,
        transaction_type,
        SUM(quantity) AS total_quantity
    FROM
        {{ ref('fct_spectra_transactions') }}
    GROUP BY
        DATE(timestamp),
        category,
        transaction_type
),
pivoted_summary AS (
    SELECT
        transaction_date,
        category,
        SUM(CASE WHEN transaction_type = 'Rental' THEN total_quantity ELSE 0 END) AS rented_quantity,
        SUM(CASE WHEN transaction_type = 'Return' THEN total_quantity ELSE 0 END) AS returned_quantity
    FROM
        daily_summary
    GROUP BY
        transaction_date, category
)
SELECT
    transaction_date,
    category,
    rented_quantity,
    returned_quantity
FROM
    pivoted_summary
