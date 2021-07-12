-- Diagnostic 
--		Win32kTraceLogging.AppInteractivitySummary
--
-- from C:\ProgramData\Microsoft\Diagnosis\EventTranscript\EventTranscript.db
-- For more info visit https://github.com/rathbuna/EventTranscript.db-Research
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
json_extract(events_persisted.payload,'$.data.EventSequence') as 'EventSequence',
json_extract(events_persisted.payload,'$.data.AggregationStartTime') as 'AggregationStartTime',
time(json_extract(events_persisted.payload,'$.data.AggregationDurationMS'),'unixepoch') as 'AggregationDuration', -- in Milliseconds
-- App name
case when substr(json_extract(events_persisted.payload,'$.data.AppId'),1,1) is 'W' -- Windows Application x32/x64
	 then substr(json_extract(events_persisted.payload,'$.data.AppId'),93)
	 when substr(json_extract(events_persisted.payload,'$.data.AppId'),1,1) is 'U' -- Universal Windows App (UWP)
	 then substr(json_extract(events_persisted.payload,'$.data.AppId'),3)
	 else json_extract(events_persisted.payload,'$.data.AppId') -- just in case ..
	 end as 'AppId',
	 
case when substr(json_extract(events_persisted.payload,'$.data.AppId'),1,1) is 'W' -- Windows Application x32/x64
	then substr(json_extract(events_persisted.payload,'$.data.AppVersion'),1,19 ) 
	end as 'AppVersion Date',	 

case when substr(json_extract(events_persisted.payload,'$.data.AppId'),1,1) is 'W' -- Windows Application x32/x64
	then substr(json_extract(events_persisted.payload,'$.data.AppVersion'),21,(instr(substr(json_extract(events_persisted.payload,'$.data.AppVersion'),21),'!')-1) )
	end as 'CRC(?)',	-- variable size (4-6)

case when substr(json_extract(events_persisted.payload,'$.data.AppId'),1,1) is 'W' -- Windows Application x32/x64
	then substr(json_extract(events_persisted.payload,'$.data.AppVersion'),(instr(substr(json_extract(events_persisted.payload,'$.data.AppVersion'),22),'!')+22)) 
	else json_extract(events_persisted.payload,'$.data.AppVersion')
	end as 'Executable',	

-- Window Size
json_extract(events_persisted.payload,'$.data.WindowWidth')||'x'||json_extract(events_persisted.payload,'$.data.WindowHeight') as 'WindowSize(WxH)',	
	
-- Activity Durations in HH:MM::SS except MouseInputSec
json_extract(events_persisted.payload,'$.data.MouseInputSec') as 'MouseInputSec', -- In Seconds
time(json_extract(events_persisted.payload,'$.data.InFocusDurationMS'),'unixepoch') as 'InFocusDuration', -- in Milliseconds
time(json_extract(events_persisted.payload,'$.data.UserActiveDurationMS'),'unixepoch') as 'UserActiveDuration', -- in Milliseconds
time(json_extract(events_persisted.payload,'$.data.SinceFirstInteractivityMS'),'unixepoch') as 'SinceFirstInteractivity', -- in Milliseconds
time(json_extract(events_persisted.payload,'$.data.UserOrDisplayActiveDurationMS'),'unixepoch') as 'UserOrDisplayActiveDuration', -- in Milliseconds

-- Focus
json_extract(events_persisted.payload,'$.data.FocusLostCount') as 'FocusLostCount',

-- Tracking
case when substr(json_extract(events_persisted.payload,'$.data.AppId'),1,1) is 'W'	-- Windows Application x32/x64
	 then upper(substr(json_extract(events_persisted.payload,'$.data.AppId'),52,40)) 
	 end as 'SHA1',	-- (SHA1 Base16) checked & verified

case when substr(json_extract(events_persisted.payload,'$.data.AppId'),1,1) is 'W'	-- Windows Application x32/x64
	then upper(substr(json_extract(events_persisted.payload,'$.data.AppId'),3,44)) 
	end as 'Hash', -- unknown
	
upper(json_extract(events_persisted.payload,'$.data.AppSessionId')) as 'AppSessionId',


-- Local, MS or AAD account 
trim(json_extract(events_persisted.payload,'$.ext.user.localId'),'m:') as 'UserId',
sid as 'User SID',


logging_binary_name


from events_persisted 
where 
-- include events:
  events_persisted.full_event_name like 'Win32kTraceLogging.AppInteractivitySummary%' 

  
 -- Sort by date descending (newest first)
order by events_persisted.timestamp desc