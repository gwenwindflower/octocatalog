select
  date_trunc('hour', pull_request_created_at) as hour_created_at,
  count(*) as pull_requests_opened
from ${pull_requests}
where pull_request_action = 'opened'
group by 1
order by 2 desc
