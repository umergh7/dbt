SELECT
    _RowNumber AS id,
    product,
    category,
    product_barcode,
    image,
    SAFE_CAST(initial_stock AS INT) AS initial_stock,
    SAFE_CAST(min_order AS INT) AS min_order,
    SAFE_CAST(restock_level AS INT) AS restock_level,
    SAFE_CAST(current_stock AS INT) AS current_stock,
    related_sales as related_rentals,
    related_purchases as related_returns
FROM {{ source('raw_datalake', 'spectra_appsheet_products') }}
