with

issue_events as (

  select * from {{ ref('stg_events') }}
  where event_type = 'IssuesEvent'

),

unnest_json as (

  SELECT
    event_id,
    actor_id,
    payload:issue.id as issue_id,
    repo_id,
    actor_login,
    repo_name,
    payload:action as issue_action,
    payload:issue.assignees as issue_assignees,
    event_created_at

  from issue_events

)

select * from unnest_json

