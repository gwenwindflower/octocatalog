{{
    config(
        materialized = 'incremental',
        unique_key = 'event_id',
    )
}}

with

pull_request_events as (

    select *, from {{ ref('stg_events') }}

    where
        event_type = 'PullRequestEvent'

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
            payload
            -> '$.pull_request'
            ->> '$.created_at'
        )::timestamp as pull_request_created_at,
        (
            payload -> '$.pull_request' ->> '$.closed_at'
        )::timestamp as pull_request_closed_at,
        (
            payload -> '$.pull_request' ->> '$.merged_at'
        )::timestamp as pull_request_merged_at,
        payload -> '$.pull_request' ->> '$.commits' as pull_request_commits,
        payload ->> '$.action' as pull_request_action,
        payload ->> '$.number' as pull_request_number,
        payload ->> '$.changes' as pull_request_changes,
        payload ->> '$.reason' as pull_request_remove_reason,
        payload -> '$.pull_request' ->> '$.id' as pull_request_id,
        payload -> '$.pull_request' ->> '$.url' as pull_request_url,
        payload -> '$.pull_request' ->> '$.state' as pull_request_state,
        payload -> '$.pull_request' ->> '$.title' as pull_request_title,
        payload -> '$.pull_request' ->> '$.body' as pull_request_body,
        payload
        -> '$.pull_request'
        ->> '$.updated_at' as pull_request_updated_at,
        payload
        -> '$.pull_request'
        ->> '$.commits' as pull_request_commits_count,
        payload
        -> '$.pull_request'
        ->> '$.comments' as pull_request_comment_count,
        payload -> '$.pull_request' -> '$.user' ->> '$.login' as user_login,
        payload -> '$.pull_request' -> '$.user' ->> '$.id' as user_id,
        payload
        -> '$.pull_request'
        -> '$.repo'
        ->> '$.full_name' as repo_full_name,

    from pull_request_events

)

select *, from unnest_json
