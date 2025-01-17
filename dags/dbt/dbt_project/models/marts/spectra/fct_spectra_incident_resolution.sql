WITH incident_user_mapping AS (
    SELECT
        inc.id AS incident_id,
        inc.title AS incident_title,
        inc.status AS incident_status,
        inc.urgency AS incident_urgency,
        inc.incident_created_at,
        inc.resolved_at,
        ROUND(TIMESTAMP_DIFF(inc.resolved_at, inc.incident_created_at, SECOND) / 60.0, 2) AS resolution_time_mins
    FROM {{ ref('stg_spectra_incidents') }} inc
),

resolution_stats AS (
    SELECT
        incident_urgency,
        COUNT(incident_id) AS total_incidents,
        AVG(resolution_time_mins) AS avg_resolution_time_mins,
        MIN(resolution_time_mins) AS min_resolution_time_mins,
        MAX(resolution_time_mins) AS max_resolution_time_mins
    FROM incident_user_mapping
    GROUP BY incident_urgency
)

SELECT
    ium.incident_id,
    ium.incident_title,
    ium.incident_status,
    ium.incident_urgency,
    ium.incident_created_at,
    ium.resolved_at,
    ium.resolution_time_mins
FROM incident_user_mapping ium
