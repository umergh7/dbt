SELECT 
    DATE(i.incident_created_at) AS incident_date,
    COUNT(*) AS daily_incident_count,
    COUNTIF(i.urgency = 'high') AS high_priority_count,
    COUNTIF(i.urgency = 'medium') AS medium_priority_count,
    COUNTIF(i.urgency = 'low') AS low_priority_count,
    AVG(TIMESTAMP_DIFF(i.resolved_at, i.incident_created_at, SECOND)) / 3600 AS avg_time_to_resolve_hours
FROM {{ ref('stg_spectra_incidents') }} i
GROUP BY incident_date
