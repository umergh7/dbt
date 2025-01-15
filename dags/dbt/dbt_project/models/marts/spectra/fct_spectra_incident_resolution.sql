WITH incident_user_mapping AS (
    SELECT
        inc.id AS incident_id,
        inc.title AS incident_title,
        inc.status AS incident_status,
        inc.urgency AS incident_urgency,
        inc.incident_created_at,
        inc.incident_resolved_at,
        inc.resolution_time_seconds,
        usr.user_name,
        usr.email AS user_email
    FROM {{ ref('stg_spectra_incidents') }} inc
    LEFT JOIN {{ ref('stg_spectra_users') }} usr
        ON inc.id = usr.id
),

resolution_stats AS (
    SELECT
        incident_urgency,
        COUNT(incident_id) AS total_incidents,
        AVG(resolution_time_seconds) AS avg_resolution_time_seconds,
        MIN(resolution_time_seconds) AS min_resolution_time_seconds,
        MAX(resolution_time_seconds) AS max_resolution_time_seconds
    FROM incident_user_mapping
    GROUP BY incident_urgency
)

SELECT
    ium.incident_id,
    ium.incident_title,
    ium.incident_status,
    ium.incident_urgency,
    ium.incident_created_at,
    ium.incident_resolved_at,
    ium.resolution_time_seconds,
    ium.user_name,
    ium.user_email
FROM incident_user_mapping ium
