{{
    config(
        materialized = 'incremental',
        unique_key = 'actor_id',
    )
}}

with

distill_user_states_from_events as (

    select
        {{
            dbt_utils.generate_surrogate_key([
                'actor_id',
                'actor_gravatar_id',
                'actor_login',
                'actor_display_login',
                'actor_url',
                'actor_avatar_url'
            ])
        }} as user_state_uuid,
        actor_id,
        actor_gravatar_id,
        actor_login,
        actor_display_login,
        actor_url,
        actor_avatar_url,
        max(event_created_at) as user_state_last_seen_at,

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

rank_user_state_recency as (

    select
        actor_id,
        actor_gravatar_id,
        actor_login,
        actor_display_login,
        actor_url,
        actor_avatar_url,
        user_state_last_seen_at as updated_at,
        row_number() over (
            partition by actor_id
            order by user_state_last_seen_at desc
        ) as user_state_recency_rank,

    from distill_user_states_from_events

),

pull_most_recent_user_state as (

    select
        actor_id,
        actor_gravatar_id,
        actor_login,
        actor_display_login,
        actor_url,
        actor_avatar_url,
        updated_at,

    from rank_user_state_recency

    where user_state_recency_rank = 1

)

select *, from pull_most_recent_user_state
