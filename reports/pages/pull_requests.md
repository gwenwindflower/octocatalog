---
title: Analyzing Pull Requests
queries:
  - prs_opened_per_hour.sql
---

## PRs Opened

<AreaChart
    data={prs_opened_per_hour}
    x=hour_created_at
    y=pull_requests_opened
/>
