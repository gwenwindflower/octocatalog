with

source as (

  select * from {{ source('github', 'github_repos') }}

),

renamed as (

  select
    repo_id,
    repo_name,
    first_seen as first_seen_at

  from source
)

select * from renamed
