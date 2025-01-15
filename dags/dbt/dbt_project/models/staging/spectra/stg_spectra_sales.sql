SELECT
    _RowNumber AS id,
    name as product_name,
    customer,
    quantity,
    current_stock,
    product_barcode,
    timestamp
FROM {{ source('raw_datalake', 'spectra_appsheet_sales') }}
