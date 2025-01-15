SELECT
    id,
    title,
    status,
    urgency,
    CAST(created_at AS TIMESTAMP) AS incident_created_at,
    CAST(last_status_change_at AS TIMESTAMP) AS last_status_change_at,
    CASE WHEN status = 'resolved' THEN CAST(last_status_change_at AS TIMESTAMP) END AS resolved_at,
    CASE WHEN status = 'acknowledged' THEN CAST(last_status_change_at AS TIMESTAMP) END AS acknowledged_at
FROM {{ source('raw_datalake', 'incidents') }}
