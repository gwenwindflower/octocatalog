with

issue_events as (

  select * from {{ ref('stg_events') }}
  where event_type = 'IssuesEvent'

),

unnest_json as (

  SELECT
    event_id,
    actor_id,
    payload -> '$.issue' ->> '$.id' as issue_id,
    payload ->> '$.action' as issue_action,
    repo_id,
    repo_name,
    actor_login,
    event_created_at

  from issue_events

)

select * from unnest_json
