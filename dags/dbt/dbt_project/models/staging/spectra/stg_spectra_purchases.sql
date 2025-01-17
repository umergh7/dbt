SELECT
    _RowNumber AS id,
    source as customer,
    product,
    CAST(quantity AS INT) AS quantity,
    PARSE_TIMESTAMP('%m/%d/%Y %H:%M:%S', timestamp) AS timestamp,
    product_barcode
FROM {{ source('raw_datalake', 'spectra_appsheet_purchases') }}
