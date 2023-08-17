with

source as (

  select * from {{ source('github', 'github_stars') }}
  where date >= dateadd('day', -7, current_date)

),

renamed as (

  select
      repo_id,
      date as starred_date,
      count as stars
  
  from source

)

select * from renamed
