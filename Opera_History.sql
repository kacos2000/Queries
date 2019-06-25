-- Opera, Chrome, Edge Browsing History
--
-- REFERENCES:
-- https://www.foxtonforensics.com/blog/post/analysing-synchronised-browser-history

select 
urls.id as 'url_id',
(select url from urls where urls.id = visits.from_visit) as 'FromVisit',
urls.title as 'title',
urls.url as 'url',
segments.name as 'segment',
urls.visit_count as 'count',
segment_usage.visit_count,
downloads.current_path 'CurrentPath',
downloads.received_bytes as 'ReceivedBytes',
downloads.total_bytes as 'TotalBytes',
case downloads.opened 
	when 0 then 'No'
	when 1 then 'Yes'
	end as 'Opened',
case 
	when downloads.last_access_time <> 0 
	then datetime((downloads.last_access_time/1000000)-11644473600,'unixepoch','localtime') 
	else '' 
	end as 'last_access_time', -- Chrome Time,
downloads.last_modified as 'last_modified',
case visit_source.source
	when 0 then 'Synced'
	when 1 then 'Browsed'
	when 2 then 'FromExtension'
	when 3 then 'Imported from Firefox'
	when 4 then 'Imported from IE'
	when 5 then 'Imported from Safari'
	else visit_source.source
	end as 'VisitSource',
datetime((downloads.end_time/1000000)-11644473600,'unixepoch','localtime') as 'Down_End', -- Chrome Time,
datetime((downloads.start_time/1000000)-11644473600,'unixepoch','localtime') as 'Down_Start', -- Chrome Time,
datetime((urls.last_visit_time/1000000)-11644473600,'unixepoch','localtime') as 'LastVisit', -- Chrome Time
datetime((visits.visit_time/1000000)-11644473600,'unixepoch','localtime') as 'VisitTime', -- Chrome Time
datetime((segment_usage.time_slot/1000000)-11644473600,'unixepoch','localtime') as 'time_slot', -- Chrome Time
time(visits.transition/1000000,'unixepoch') as 'transition',
time(visits.visit_duration/1000000,'unixepoch') as 'duration',
keyword_search_terms.lower_term as'SearchLowerTerm',
keyword_search_terms.term as 'SearchTerm'

from urls
left join visits on urls.id = visits.id
left join visit_source on visit_source.id = visits.id 
left join segments on urls.id = segments.url_id
left join segment_usage on segments.id =  segment_usage.segment_id
left join keyword_search_terms on keyword_search_terms.url_id = urls.id
left join downloads_url_chains on downloads_url_chains.url = urls.url
left join downloads on downloads.id = downloads_url_chains.id
order by count desc, lastvisit desc