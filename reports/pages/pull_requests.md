---
title: Analyzing Pull Requests
---

## PRs opened per hour

```sql pr_actions

select distinct pull_request_action from quack.pull_requests

```

<Dropdown
  name="pr_action"
  data={pr_actions}
  value=pull_request_action
/>

```sql prs_acted_on_per_hour
select
    date_trunc('hour', event_created_at) as hour_event_at,
    count(*) as pull_requests_acted_on
from quack.pull_requests
where pull_request_action = '${inputs.pr_action}'
group by 1
order by 2
```

<AreaChart
  data={prs_acted_on_per_hour}
  x=hour_event_at
  y=pull_requests_acted_on
/>
