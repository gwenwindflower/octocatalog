{{
    config(
        materialized = 'incremental',
        unique_key = 'repo_id',
    )
}}

with

distill_repos_from_events as (

    select
        {{
            dbt_utils.generate_surrogate_key([
                'repo_id',
                'repo_name',
                'repo_url'
            ])
        }} as repo_state_uuid,
        repo_id,
        repo_name,
        repo_url,
        max(event_created_at) as repo_state_last_seen_at,

    from {{ ref('stg_events') }}

    where
        true

        {% if is_incremental() %}
            and event_created_at >= coalesce(
                (select max(updated_at), from {{ this }}), '1900-01-01'
            )
        {% endif %}

    group by all

),

rank_most_recent_repo_state as (

    select
        -- we probably should group down to id for repos that change names?
        repo_id,
        repo_name,
        repo_url,
        repo_state_last_seen_at as updated_at,
        row_number() over (
            partition by repo_id
            order by repo_state_last_seen_at desc
        ) as repo_recency_rank,

    from distill_repos_from_events

),

pull_most_recent_repo_state as (

    select
        repo_id,
        repo_name,
        repo_url,
        updated_at,

    from rank_most_recent_repo_state

    where repo_recency_rank = 1

)

select *, from pull_most_recent_repo_state
