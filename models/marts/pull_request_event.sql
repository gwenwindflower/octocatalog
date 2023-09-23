with

pull_request_events as (

    select * from {{ ref('stg_events') }}

    where event_type = 'PullRequestEvent'

),

unnest_json as (

    select *

    from pull_request_events

)

select * from unnest_json
