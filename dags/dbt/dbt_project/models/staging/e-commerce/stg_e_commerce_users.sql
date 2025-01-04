SELECT
    id,
    JSON_EXTRACT_SCALAR(name, '$.firstname') AS first_name,
    JSON_EXTRACT_SCALAR(name, '$.lastname') AS last_name,
    email,
    phone,
    JSON_EXTRACT_SCALAR(address, '$.city') AS city,
    JSON_EXTRACT_SCALAR(address, '$.geolocation.lat') AS latitude,
    JSON_EXTRACT_SCALAR(address, '$.geolocation.long') AS longitude,
    JSON_EXTRACT_SCALAR(address, '$.number') AS house_number,
    JSON_EXTRACT_SCALAR(address, '$.street') AS street,
    JSON_EXTRACT_SCALAR(address, '$.zipcode') AS zipcode,
    password,
    username
FROM {{ source ('e_commerce', 'users') }}
