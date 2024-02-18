---
title: Analyzing Issues
---

In the last <Value data={issue_summary} column="last_hours"/> hours there have been <b><Value data={issue_summary} column="issues" fmt="num0 auto"/></b> events across <Value data={issue_summary} column="repo_count" fmt="num0 auto"/> repositories! This has involved <Value data={issue_summary} column="actor_count" fmt="num0 auto"/> contributors opening and closing issues, <Value data={issue_summary} column="opened_events" fmt="num0 auto"/> and <Value data={issue_summary} column="closed_events" fmt="num0 auto"/> respectively.

<b><Value data={top_actor} /></b> was the top contributor with <b><Value data={top_actor_repo} column="repo_events"/></b> issues added to <b><Value data={top_actor_repo} column="repo_name"/></b> repository!

<BigValue
    data={issue_count}
    sparkline='date'
    comparison='count_day_prior'
    comparisonTitle="Compared to Yesterday"
    value='issues'
    maxWidth='10em'
/>

<BigValue
    data={issue_summary}
    value='repo_count'
    maxWidth='10em'
/>

<BigValue
    data={issue_summary}
    value='actor_count'
    maxWidth='10em'
/>

### Issues by hour

<BarChart
  data={issue_count_hour}
  x="hour_of_day"
  y="issues"
  series="issue_action"
/>

### Issues summary by repo

<DataTable
  data="{issues_per_repo}"
  search="true"
  link="issue_repo_url">
<Column id= "repo_name"/>
<Column id= "actors"/>
<Column id= "closed_events"/>
<Column id= "closed_events"/>
<Column id= "number_of_issues"/>
</DataTable>

_The longest content issue in the data set reads:_ <Value data={issue_content_len} />

<Details title="Definitions">

```sql issue_summary
select
  count(1)::INT as issues,
  count(distinct actor_id)::INT as actor_count,
  count(distinct repo_id)::INT as repo_count,
  date_diff('hour', min(event_created_at)::TIMESTAMP, now()::TIMESTAMP) as last_hours,
  count(1) filter(where issue_action = 'opened')::INT as opened_events,
  count(1) filter(where issue_action = 'closed')::INT as closed_events,
from motherduck.issues

```

<!-- Actor summary -->

```sql top_actor
  select
    actor_login,
    count(1) as actor_events,
  from motherduck.issues
  group by all
  having actor_events>1
  order by actor_login desc
  limit 1
```

```sql top_actor_repo
  select repo_name,
    count(1) as repo_events
  from motherduck.issues
  where actor_login = (select actor_login from ${top_actor})
  group by all
  limit 1
```

```sql issue_content_len
  select
    left(issue_body, 400) as content_summary,
    issue_body,
    length(issue_body) as issue_body_len,
  from motherduck.issues
  group by all
  order by issue_body_len desc
  limit 1
```

```sql issue_count
  select count(1) as issues,
    count(1) - count(1) filter(where issue_created_at < now()::timestamp - interval '1 Day') as count_day_prior,
  from motherduck.issues
  group by all
```

```sql issue_count_hour
  select
    date_trunc('hour', event_created_at) as hour_of_day,
    case
      when issue_action = 'opened' then 'Opened'
      when issue_action = 'closed' then 'Closed'
      else issue_action
      end as issue_action,
    count(1) as issues,
  from motherduck.issues
  group by all
  order by all

```

```sql issues_per_repo
select
  repo_name,
  issue_repo_url,
  count(distinct issue_id) as number_of_issues,
  count(distinct actor_id) as actors,
  count(1) filter(where issue_action = 'opened') as opened_events,
  count(1) filter(where issue_action = 'closed') as closed_events,
from motherduck.issues
group by all
having number_of_issues > 2
order by 2 desc
```

</Details>
