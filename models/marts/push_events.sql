{{
    config(
        materialized = 'incremental',
        unique_key = 'event_id',
    )
}}

with

push_events as (

    select *, from {{ ref('stg_events') }}

    where
        event_type in ('PushEvent')

        {% if is_incremental() %}
            and event_created_at >= coalesce(
                (select max(event_created_at), from {{ this }}), '1900-01-01'
            )
        {% endif %}

),

unnest_json as (

    select
        event_id,
        actor_id,
        payload,
        repo_id,
        repo_name,
        actor_login,
        event_created_at,
        payload ->> '$.push_id' as push_id,
        payload ->> '$.size' as push_size,
        payload ->> '$.distinct_size' as push_distinct_size,
        payload -> '$.commits' as push_commits,

    from push_events

)

select *, from unnest_json
