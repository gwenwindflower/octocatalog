with

distill_repos_from_events as (

    select
        {{ dbt_utils.generate_surrogate_key([
            'repo_id',
            'repo_name',
            'repo_url'
        ]) }} as repo_uuid,
        repo_id,
        repo_name,
        repo_url,
        max(event_created_at) as repo_state_last_seen_at,

    from {{ ref('stg_events') }}

    group by all

),

rank_most_recent_repo_state as (

    select
        repo_id,
        repo_name,
        repo_url,
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

    from rank_most_recent_repo_state

    where repo_recency_rank = 1

)

select *, from pull_most_recent_repo_state
