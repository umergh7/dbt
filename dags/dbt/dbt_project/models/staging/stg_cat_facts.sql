{{ config(
    tags=["cats"]
) }}

select *

FROM {{ source ('dbt_project', 'cat_facts') }}