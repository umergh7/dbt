{{ config(
    tags=["cats"]
) }}

SELECT
fact,
count(fact) as count
FROM {{ ref('stg_cat_facts') }}
group by 1