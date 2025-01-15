SELECT
    _RowNumber AS id,
    source as customer,
    product,
    quantity,
    timestamp,
    product_barcode
FROM {{ source('raw_datalake', 'spectra_appsheet_purchases') }}
