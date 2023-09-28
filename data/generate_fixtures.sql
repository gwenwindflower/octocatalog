COPY (
    select
        any_value(id) as id,
        type,
        any_value(actor) as actor,
        any_value(repo) as repo,
        any_value(payload) as payload,
        public,
        any_value(created_at) as created_at,
        any_value(org) as org,

    from read_ndjson(
            "2023-09-26-10.json",
            columns={
                'id': 'VARCHAR',
                'type': 'VARCHAR',
                'actor': 'STRUCT(
                    id VARCHAR,
                    login VARCHAR,
                    display_login VARCHAR,
                    gravatar_id VARCHAR,
                    url VARCHAR,
                    avatar_url VARCHAR
                )',
                'repo': 'STRUCT(id VARCHAR, name VARCHAR, url VARCHAR)',
                'payload': 'VARCHAR',
                'public': 'BOOLEAN',
                'created_at': 'TIMESTAMP',
                'org': 'STRUCT(
                    id VARCHAR,
                    login VARCHAR,
                    gravatar_id VARCHAR,
                    url VARCHAR,
                    avatar_url VARCHAR
                )'
            }
        )
    group by type, public
) to 'testing.json';
