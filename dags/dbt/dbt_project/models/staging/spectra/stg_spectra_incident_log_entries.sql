SELECT
    id,
    JSON_VALUE(incident, '$.id') AS incident_id,
    CASE 
        WHEN LOWER(summary) LIKE '%resolved by%' THEN 
            REGEXP_EXTRACT(summary, r'Resolved by\s(.*)')
        WHEN LOWER(summary) LIKE '%acknowledged by%' THEN 
            REGEXP_EXTRACT(summary, r'Acknowledged by\s(.*)')
        ELSE NULL
    END AS user,
    type,
    CAST(created_at AS TIMESTAMP) AS created_at
FROM {{ source('raw_datalake', 'incident_log_entries') }}
