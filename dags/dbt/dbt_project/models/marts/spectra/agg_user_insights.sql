SELECT 
    u.name AS user_name,
    u.email,
    COUNT(DISTINCT i.id) AS total_incidents_handled,
    AVG(TIMESTAMP_DIFF(i.resolved_at, i.incident_created_at, SECOND)) / 3600 AS avg_time_to_resolve_hours
FROM {{ ref('stg_spectra_incidents') }} i
LEFT JOIN {{ ref('stg_spectra_incident_log_entries') }} le
    ON i.id = le.incident_id
LEFT JOIN {{ ref('stg_spectra_users') }} u
    ON le.user = u.name
WHERE i.resolved_at IS NOT NULL
AND u.name IS NOT NULL
GROUP BY user_name, email
