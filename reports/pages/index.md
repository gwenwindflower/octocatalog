---
title: Github Archive Analysis
---

<BarChart
  data={top_users_by_pull_requests}
  y="number_of_prs"
  title = "Top 10 Users by Pull Requests"
/>

## Queries

```sql top_users_by_pull_requests
select
  user_login,
  count(distinct pull_request_id) as number_of_prs,
from pull_request_events
where user_login not like ('%[bot]')
group by 1 order by 2 desc
limit 10
```
