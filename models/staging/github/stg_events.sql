with

source as (

  select * from {{ source('github', 'github_events') }}

),

renamed as (

  select
    id,
    created_at_timestamp,
    type,
    actor_avatar_url,
    actor_display_login,
    actor_gravatar_id,
    actor_id,
    actor_login,
    actor_url,
    repo_id,
    repo_name,
    repo_url,
    org_avatar_url,
    org_gravatar_id,
    org_id,
    org_login,
    org_url,
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
    public,
    load_date,
    created_at,
    payload_body,
    payload_commit_id,
    payload_created_at,
    payload_user_id,
    payload_user_login,
    issue,
    issue_active_lock_reason,
    issue_assignee,
    issue_assignees,
    issue_author_association,
    issue_body,
    issue_closed_at,
    issue_comments,
    issue_comments_url,
    issue_created_at,
    issue_draft,
    issue_events_url,
    issue_html_url,
    issue_id,
    issue_labels,
    issue_labels_url,
    issue_locked,
    issue_milestone,
    issue_node_id,
    issue_number,
    issue_performed_via_github_app,
    issue_pull_request,
    issue_reactions,
    issue_repository_url,
    issue_state,
    issue_timeline_url,
    issue_title,
    issue_updated_at,
    issue_url,
    issue_user_id,
    issue_user_login,
    issue_user_type

  from source

)

select * from renamed
