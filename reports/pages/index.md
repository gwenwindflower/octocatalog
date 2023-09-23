---
title: Github Archive Analysis
---

<BarChart
  data={top_users_by_pull_requests}
  x="user_login"
  y="number_of_prs"
  title = "Top 10 Users by Pull Requests"
/>

<BarChart
  data={issues_per_repo}
  x="repo_name"
  y="number_of_issues"
  title = "Issues per Repository"
/>

<LineChart
  data={issues_per_day}
  x="created_date"
  y="number_of_issues"
  title = "Issues per Day"
/>

<BarChart
  data={repos_with_most_unique_contributors}
  x="repo_name"
  y="number_of_contributors"
  title = "Repos with Most Unique Contributors"
/>

```sql top_users_by_pull_requests
select
  user_login,
  count(distinct pull_request_id) as number_of_prs,
from octocatalog.pull_request_events
where user_login not like ('%[bot]')
group by 1
order by 2 desc
limit 10
```

```sql issues_per_repo
select
  repo_name,
  count(distinct issue_id) as number_of_issues,
from octocatalog.issue_events
group by 1
having number_of_issues > 2
order by 2 desc
```

```sql issues_per_day
select
  date_trunc('day', issue_created_at) as created_date,
  count(distinct issue_id) as number_of_issues,
from octocatalog.issue_events
group by 1
order by 1
```

```sql repos_with_most_unique_contributors
select
  repos.repo_name,
  count(distinct pull_request_events.user_id) as number_of_contributors,
from octocatalog.pull_request_events
left join octocatalog.repos on repos.repo_id = pull_request_events.repo_id
where
  pull_request_events.user_login not like ('%[bot]') and
  pull_request_events.pull_request_merged_at is not null
group by 1
having number_of_contributors > 2
```
