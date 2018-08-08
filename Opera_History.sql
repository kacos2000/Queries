select 
urls.id as 'url_id',
visits.from_visit as 'Previous_url_id',
urls.title as 'title',
urls.url as 'url',
segments.name as 'name',
urls.visit_count as 'count',
segment_usage.visit_count,
downloads.current_path 'Download_path',
downloads.received_bytes as 'ReceivedBytes',
downloads.total_bytes as 'TotalBytes',
downloads.opened as 'Opened',
case when downloads.last_access_time <> 0 then datetime((downloads.last_access_time/1000000)-11644473600,'unixepoch','localtime') else '' end as 'last_access_time', -- Chrome Time,
downloads.last_modified as 'last_modified', 
datetime((downloads.end_time/1000000)-11644473600,'unixepoch','localtime') as 'Down_End', -- Chrome Time,
datetime((downloads.start_time/1000000)-11644473600,'unixepoch','localtime') as 'Down_Start', -- Chrome Time,
datetime((urls.last_visit_time/1000000)-11644473600,'unixepoch','localtime') as 'LastVisit', -- Chrome Time
datetime((visits.visit_time/1000000)-11644473600,'unixepoch','localtime') as 'VisitTime', -- Chrome Time
datetime((segment_usage.time_slot/1000000)-11644473600,'unixepoch','localtime') as 'time_slot', -- Chrome Time
time((visits.transition/1000000)-11644473600,'unixepoch','localtime') as 'transition',
time((visits.visit_duration/1000000)-11644473600,'unixepoch','localtime') as 'duration',
keyword_search_terms.lower_term as'LowerTerm',
keyword_search_terms.term as 'Term'

from urls
left join visits on urls.id = visits.id 
left join segments on urls.id = segments.url_id
left join segment_usage on segments.id =  segment_usage.segment_id
left join keyword_search_terms on keyword_search_terms.url_id = urls.id
left join downloads on urls.url = downloads.referrer or urls.url = downloads.tab_referrer_url
order by urls.id desc, visits.from_visit desc, lastvisit desc