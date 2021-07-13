-- Diagnostic 
--      Win32kTraceLogging.AppInteractivity &
--		Win32kTraceLogging.AppInteractivitySummary
--
-- from C:\ProgramData\Microsoft\Diagnosis\EventTranscript\EventTranscript.db
-- For more info visit https://github.com/rathbuna/EventTranscript.db-Research 
-- https://docs.microsoft.com/en-us/windows/privacy/enhanced-diagnostic-data-windows-analytics-events-and-fields
-- and "Forensic Quick Wins With EventTranscript.DB: Win32kTraceLogging" at
-- https://www.kroll.com/en/insights/publications/cyber/forensically-unpacking-eventtranscript/forensic-quick-wins-with-eventtranscript


SELECT

--Timestamp from db field
json_extract(events_persisted.payload,'$.time') as 'UTC TimeStamp',
-- Timestamp from json payload
datetime((timestamp - 116444736000000000)/10000000, 'unixepoch','localtime') as 'Local TimeStamp',
json_extract(events_persisted.payload,'$.ext.loc.tz') as 'TimeZome',
json_extract(events_persisted.payload,'$.ext.utc.seq') as 'seq', 

-- events
json_extract(events_persisted.payload,'$.data.EventSequence') as 'EventSequence', -- AppInteractivity% specific
json_extract(events_persisted.payload,'$.data.AggregationStartTime') as 'AggregationStartTime (UTC)', -- Start date and time of AppInteractivity aggregation
time(json_extract(events_persisted.payload,'$.data.AggregationDurationMS'),'unixepoch') as 'AggregationDuration', -- Actual duration of aggregation period (in milliseconds)
-- App name
case when substr(json_extract(events_persisted.payload,'$.data.AppId'),1,1) is 'W' -- Windows Application x32/x64
	 then substr(json_extract(events_persisted.payload,'$.data.AppId'),93)
	 when substr(json_extract(events_persisted.payload,'$.data.AppId'),1,1) is 'U' -- Universal Windows App (UWP)
	 then substr(json_extract(events_persisted.payload,'$.data.AppId'),3)
	 else json_extract(events_persisted.payload,'$.data.AppId') -- just in case ..
	 end as 'AppId',

-- Focus
case json_extract(events_persisted.payload,'$.data.FocusState') 
	when 0 then 'Back'
	when 1 then 'In Focus'
	else json_extract(events_persisted.payload,'$.data.FocusState') 
	end as 'FocusState',
time(json_extract(events_persisted.payload,'$.data.FocusDurationMS'),'unixepoch') as 'FocusDuration',
json_extract(events_persisted.payload,'$.data.FocusLostCount') as 'FocusLostCount', -- Number of times that an app lost focus during the aggregation period
	 
	 
-- Version of the application that produced this event	
case when substr(json_extract(events_persisted.payload,'$.data.AppId'),1,1) is 'W' -- Windows Application x32/x64
	then substr(json_extract(events_persisted.payload,'$.data.AppVersion'),1,19 ) 
	end as 'AppVersion Date',   -- Same as the 'LinkDate' in Amcache.hve (Root\InventoryApplicationFile\)	 

case when substr(json_extract(events_persisted.payload,'$.data.AppId'),1,1) is 'W' -- Windows Application x32/x64
	then substr(json_extract(events_persisted.payload,'$.data.AppVersion'),21,(instr(substr(json_extract(events_persisted.payload,'$.data.AppVersion'),21),'!')-1) )
	end as 'PE Header CheckSum',	-- PE Header CheckSum variable size (4-6)

case substr(json_extract(events_persisted.payload,'$.data.AppId'),1,1) 
	when 'W' then 'Win' -- Windows Application x32/x64
	when 'U' then 'UWP' -- Universal Windows App (UWP)
	end as 'Type',	
	
case when substr(json_extract(events_persisted.payload,'$.data.AppId'),1,1) is 'W' -- Windows Application x32/x64
	then substr(json_extract(events_persisted.payload,'$.data.AppVersion'),(instr(substr(json_extract(events_persisted.payload,'$.data.AppVersion'),22),'!')+22)) 
	else json_extract(events_persisted.payload,'$.data.AppVersion')
	end as 'Executable',	

-- Window Size
json_extract(events_persisted.payload,'$.data.WindowWidth')||'x'||json_extract(events_persisted.payload,'$.data.WindowHeight') as 'WindowSize(WxH)',	
	
-- Activity Durations in HH:MM::SS except MouseInputSec
time(json_extract(events_persisted.payload,'$.data.FocusDurationMS'),'unixepoch') as 'FocusDuration',
json_extract(events_persisted.payload,'$.data.MouseInputSec') as 'MouseInputSec', -- Total number of seconds during which there was mouse input (In Seconds)
time(json_extract(events_persisted.payload,'$.data.InFocusDurationMS'),'unixepoch') as 'InFocusDuration', -- Total time (in milliseconds) the application had focus
time(json_extract(events_persisted.payload,'$.data.UserActiveDurationMS'),'unixepoch') as 'UserActiveDuration', -- Total time that the user was active including all input methods
time(json_extract(events_persisted.payload,'$.data.SinceFirstInteractivityMS'),'unixepoch') as 'SinceFirstInteractivity', -- in Milliseconds
time(json_extract(events_persisted.payload,'$.data.UserOrDisplayActiveDurationMS'),'unixepoch') as 'UserOrDisplayActiveDuration', -- Total time the user was using the display

-- Focus
json_extract(events_persisted.payload,'$.data.FocusLostCount') as 'FocusLostCount', -- Number of times that an app lost focus during the aggregation period

-- Tracking
case when substr(json_extract(events_persisted.payload,'$.data.AppId'),1,1) is 'W'	-- Windows Application x32/x64
	 then upper(substr(json_extract(events_persisted.payload,'$.data.AppId'),52,40)) -- (removed 0x0000 from the start of the hash)
	 -- Same as the 'FileId' in Amcache.hve (Root\InventoryApplicationFile\)
	 end as 'SHA1',	-- (SHA1 Base16) checked & verified 

case when substr(json_extract(events_persisted.payload,'$.data.AppId'),1,1) is 'W'	-- Windows Application x32/x64
	then upper(substr(json_extract(events_persisted.payload,'$.data.AppId'),3,44)) 
	end as 'ProgramId', -- Same as the 'ProgramId' in Amcache.hve (Root\InventoryApplicationFile\)
	
upper(json_extract(events_persisted.payload,'$.data.AppSessionId')) as 'AppSessionId',


-- Local, MS or AAD account 
trim(json_extract(events_persisted.payload,'$.ext.user.localId'),'m:') as 'UserId',
sid as 'User SID',


tag_descriptions.tag_name, -- where you'll see these events in MS Diagnostic Data Viewer app
logging_binary_name


from events_persisted 
join event_tags on events_persisted.full_event_name_hash = event_tags.full_event_name_hash
join tag_descriptions on event_tags.tag_id = tag_descriptions.tag_id 
where 
-- include events:
  events_persisted.full_event_name in ('Win32kTraceLogging.AppInteractivity','Win32kTraceLogging.AppInteractivitySummary' )

 -- Sort by event datedescending (newest first)
order by cast(events_persisted.timestamp as integer) desc