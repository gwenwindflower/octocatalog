{{
    config(
        materialized = 'incremental',
        unique_key = 'event_id',
    )
}}

with

issue_events as (

    select *, from {{ ref('stg_events') }}

    where
        event_type = 'IssuesEvent'

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
        (
            payload -> '$.issue' ->> '$.created_at'
        )::timestamp as issue_created_at,
        payload ->> '$.action' as issue_action,
        payload -> '$.issue' ->> '$.id' as issue_id,
        payload -> '$.issue' ->> '$.url' as issue_url,
        payload -> '$.issue' ->> '$.repository_url' as issue_repo_url,
        payload -> '$.issue' ->> '$.state' as issue_state,
        payload -> '$.issue' ->> '$.state_reason' as issue_state_reason,
        payload -> '$.issue' ->> '$.body' as issue_body,
        payload ->> '$.changes' as issue_changes,
        payload ->> '$.label' as issue_label,
        payload ->> '$.assignee' as issue_assignee,

    from issue_events

)

select *, from unnest_json
