with

source as (

    select * from {{ source('octocatalog', 'github_events') }}

),


renamed as (

    select
        --- event
        id as event_id,
        type as event_type,
        public as is_event_public,
        created_at as event_created_at,

        payload,

        --- actor
        actor['id'] as actor_id,
        actor['gravatar_id'] as actor_gravatar_id,
        actor['login'] as actor_login,
        actor['display_login'] as actor_display_login,
        actor['url'] as actor_url,
        actor['avatar_url'] as actor_avatar_url,

        --- repo
        repo['id'] as repo_id,
        repo['name'] as repo_name,
        repo['url'] as repo_url,

        --- org
        org['id'] as org_id,
        org['login'] as org_login,
        org['gravatar_id'] as org_gravatar_id,
        org['url'] as org_url,
        org['avatar_url'] as org_avatar_url

    from source

)

select * from renamed
