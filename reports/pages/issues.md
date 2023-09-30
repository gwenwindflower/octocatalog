---
title: Analyzing Issues
sources:
  - issues.sql
---

In the last <Value data={issue_summary} column="last_hours"/> hours there have been <b><Value data={issue_summary} column="issues"/></b> events across <Value data={issue_summary} column="repo_count"/> repositories! This has involved <Value data={issue_summary} column="actor_count"/> contributors opening and closing issues, <Value data={issue_summary} column="opened_events"/> and <Value data={issue_summary} column="closed_events"/> respectively.


<!-- Coming soon! You could contribute this page! -->
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
  search="true"
  data="{issues_per_repo}"
  link="issue_repo_url"
  >
  <Column id= "repo_name"/>
  <Column id= "actors"/>
  <Column id= "closed_events"/>
  <Column id= "closed_events"/>
  <Column id= "number_of_issues"/>
</DataTable>

## Issue Sample
```sql issuesraw
select * from ${issues} limit 100
```
<Details title="Definitions">

```sql issue_summary
select 
  count(1)::INT as issues,
  count(distinct actor_id)::INT as actor_count,
  count(distinct repo_id)::INT as repo_count,
  date_diff('hour', min(event_created_at)::TIMESTAMPTZ, now()::TIMESTAMPTZ) as last_hours,
  count(1) filter(where issue_action = 'opened')::INT as opened_events,
  count(1) filter(where issue_action = 'closed')::INT as closed_events,
  from ${issues}

```

```sql issue_count
  select count(1) as issues,
    count(1) - count(1) filter(where issue_created_at < now() AT TIME ZONE 'UTC' - interval '1 Day') as count_day_prior,
  from ${issues} 
  group by all
```

```sql issue_count_hour
  select 
    date_trunc('hour', event_created_at) as hour_of_day,
    case 
      when issue_action = 'opened' then 'Opened'
      when issue_action = 'closed' then 'Closed'
      else 'Unknown'
      end as issue_action,
    count(1) as issues,
  from ${issues} 
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
from ${issues}
group by all
having number_of_issues > 2
order by 2 desc
```

</Details>
