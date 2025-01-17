SELECT
    _RowNumber AS id,
    name as product_name,
    customer,
    CAST(quantity AS INT) AS quantity,
    CAST(current_stock AS INT) AS current_stock,
    product_barcode,
    PARSE_TIMESTAMP('%m/%d/%Y %H:%M:%S', timestamp) AS timestamp
FROM {{ source('raw_datalake', 'spectra_appsheet_sales') }}
