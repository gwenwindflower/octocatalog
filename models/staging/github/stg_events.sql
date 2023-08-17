with

source as (

  select * from {{ source('github', 'github_events') }}
  where created_at_timestamp >= dateadd('day', -1, current_timestamp)

),

renamed as (

  select
    --- event
    id as event_id,
    type as event_type,
    public as is_event_public,
    load_date as event_load_date,
    created_at_timestamp as event_created_at,

    --- actor
    actor_id,
    actor_gravatar_id,
    actor_login,
    actor_display_login,
    actor_url,
    actor_avatar_url,

    --- repo
    repo_id,
    repo_name,
    repo_url,

    --- org
    org_id,
    org_gravatar_id,
    org_url,
    org_login,
    org_avatar_url,

    -- payload
    payload,
    payload_action,
    payload_description,
    payload_comment,
    payload_master_branch,
    payload_pull_request,
    payload_pusher_type,
    payload_push_id,
    payload_head,
    payload_ref,
    payload_ref_type,
    payload_issue_id,
    payload_issue,
    payload_body,
    payload_commit_id,
    payload_created_at,
    payload_user_id,
    payload_user_login

  from source

)

select * from renamed
