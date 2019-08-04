-- Opera, Chrome, Edge Browsing History
--
-- REFERENCES:
-- https://www.foxtonforensics.com/blog/post/analysing-synchronised-browser-history
-- https://dfir.blog/chrome-values-lookup-tables/amp/

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
case downloads.danger_type
	when 0 then "Not Dangerous"
	when 1 then "Dangerous"
	when 2 then "Dangerous URL"
	when 3 then "Dangerous Content"
	when 4 then "Content May Be Malicious"
	when 5 then "Uncommon Content"
	when 6 then "Dangerous But User Validated"
	when 7 then "Dangerous Host"
	when 8 then "Potentially Unwanted"
	when 9 then "Whitelisted by Policy"
	end as 'DangerType',
 case downloads.interrupt_reason
	when 0 then "Success"
	when 1 then "File Error"
	when 2 then "Access Denied"
	when 3 then "Disk Full"
	when 5 then "Path Too Long"
	when 6 then "File Too Large"
	when 7 then "Virus"
	when 10 then "Temporary Problem"
	when 11 then "Blocked"
	when 12 then "Security Check Failed"
	when 13 then "Resume Error"
	when 20 then "Network Error"
	when 21 then "Operation Timed Out"
	when 22 then "Connection Lost"
	when 23 then "Server Down"
	when 30 then "Server Error"
	when 31 then "Range Request Error"
	when 32 then "Server Precondition Error"
	when 33 then "Unable to get file"
	when 34 then "Server Unauthorized"
	when 35 then "Server Certificate Problem"
	when 36 then "Server Access Forbidden"
	when 37 then "Server Unreachable"
	when 38 then "Content Length Mismatch"
	when 39 then "Cross Origin Redirect"
	when 40 then "Cancelled"
	when 41 then "Browser Shutdown"
	when 50 then "Browser Crashed"
	end as 'InterruptReason',
case downloads.state
	when 0 then "In Progress"
	when 1 then "Complete"
	when 2 then "Cancelled"
	when 3 then "Interrupted"
	when 4 then "Interrupted"
	end as 'State',
	
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
left join downloads on downloads.tab_url = urls.url 
order by count desc, lastvisit desc