SELECT
    _RowNumber AS id,
    product,
    category,
    product_barcode,
    image,
    initial_stock,
    min_order,
    restock_level
    current_stock,
    related_sales as related_rentals,
    related_purchases as related_returns
FROM {{ source('raw_datalake', 'spectra_appsheet_products') }}
