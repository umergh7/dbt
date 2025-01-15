WITH expanded_orders AS (
  SELECT 
    id AS order_id,
    JSON_VALUE(answers, '$.4.answer.first') || ' ' || JSON_VALUE(answers, '$.4.answer.last') AS full_name,
    JSON_VALUE(answers, '$.6.answer') AS company,
    JSON_VALUE(answers, '$.7.answer') AS project_number,
    JSON_VALUE(answers, '$.5.answer') AS email,
    JSON_EXTRACT(answers, '$.9.answer') AS order_information_raw,  -- Raw order information for debugging
    JSON_VALUE(answers, '$.10.answer.datetime') AS pickup_date,
    JSON_VALUE(answers, '$.11.answer.datetime') AS drop_off_date,
    JSON_VALUE(answers, '$.12.answer') AS extra_details,
    JSON_VALUE(answers, '$.15.answer') AS submission_number
  FROM {{ source('raw_datalake', 'submissions') }}
)
SELECT
  GENERATE_UUID() AS unique_id,  -- Generate a unique UUID for each row
  order_id,
  full_name,
  company,
  project_number,
  email,
  CAST(JSON_EXTRACT_SCALAR(order_information_raw, '$') AS STRING) AS order_information,  -- Cast JSON to string
  pickup_date,
  drop_off_date,
  extra_details,
  submission_number
FROM expanded_orders
