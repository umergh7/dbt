SELECT
    id,
    name,
    email
FROM {{ source('raw_datalake', 'users') }}
