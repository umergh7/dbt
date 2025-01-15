-- marts/order_information_parsed.sql

WITH parsed_order_info AS (
    SELECT
        GENERATE_UUID() AS unique_id,  -- Generate a unique ID for each row
        order_id,
        full_name,
        company,
        project_number,
        email,
        pickup_date,
        drop_off_date,
        extra_details,
        submission_number,
        -- Parsing the JSON array in 'order_information' to extract 'Equipment' and 'Quantity'
        JSON_EXTRACT_ARRAY(order_information) AS order_items_raw,
        
        -- Extracting 'Equipment' and 'Quantity' using REGEXP_EXTRACT
        ARRAY(
            SELECT AS STRUCT 
                REGEXP_EXTRACT(item, r'"Equipment":"([^"]+)"') AS equipment,
                REGEXP_EXTRACT(item, r'"Quantity":"([^"]+)"') AS quantity
            FROM UNNEST(JSON_EXTRACT_ARRAY(order_information)) AS item
        ) AS parsed_order_items
    FROM {{ ref('stg_spectra_submissions') }}  -- Referencing your staging model
)

-- Final output with parsed order information
SELECT
    unique_id,
    order_id,
    full_name,
    company,
    project_number,
    email,
    pickup_date,
    drop_off_date,
    item.equipment,
    item.quantity
    extra_details,
    submission_number
FROM parsed_order_info,
UNNEST(parsed_order_items) AS item
