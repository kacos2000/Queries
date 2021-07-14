-- Diagnostic 
--           KernelProcess.AppStateChangeSummary
-- from C:\ProgramData\Microsoft\Diagnosis\EventTranscript\EventTranscript.db

SELECT

--Timestamp from db field
json_extract(events_persisted.payload,'$.time') as 'UTC TimeStamp',

-- Timestamp from json payload
datetime((timestamp - 116444736000000000)/10000000, 'unixepoch','localtime') as 'Local TimeStamp',
json_extract(events_persisted.payload,'$.ext.loc.tz') as 'TimeZome',
json_extract(events_persisted.payload,'$.ext.utc.seq') as 'seq', 

-- Event
replace( events_persisted.full_event_name,'KernelProcess.AppStateChangeSummary','') as 'Event',

-- Counters
json_extract(events_persisted.payload,'$.data.LaunchCount') as 'LaunchCount',
json_extract(events_persisted.payload,'$.data.SuspendCount') as 'SuspendCount',
json_extract(events_persisted.payload,'$.data.ResumeCount') as 'ResumeCount',
json_extract(events_persisted.payload,'$.data.TerminateCount') as 'TerminateCount',
json_extract(events_persisted.payload,'$.data.CrashCount') as 'CrashCount',


-- Target App Info
case json_extract(events_persisted.payload,'$.data.TargetAppType') 
	when 'Modern' then json_extract(events_persisted.payload,'$.data.TargetAppType')||" (UWP)"
	when 'Desktop' then json_extract(events_persisted.payload,'$.data.TargetAppType')||" (Win)"
 	else json_extract(events_persisted.payload,'$.data.TargetAppType')
	end as 'TargetAppIdType',

-- Target Application Name
case when substr(json_extract(events_persisted.payload,'$.data.TargetAppId'),1,1) is 'W' -- Windows Application x32/x64
	then substr(json_extract(events_persisted.payload,'$.data.TargetAppId'),93) 
	else substr(json_extract(events_persisted.payload,'$.data.TargetAppId'),3)
	end as 'TargetAppId Name',	

-- SHA1 Hash of the application that produced this event	
case when substr(json_extract(events_persisted.payload,'$.data.TargetAppId'),1,1) is 'W' -- Windows Application x32/x64
	then upper(substr(json_extract(events_persisted.payload,'$.data.TargetAppId'),52,40 ))
	-- Same as the 'FileId' in Amcache.hve (Root\InventoryApplicationFile\)
	end as 'Target AppId SHA1',	-- (SHA1 Base16) checked & verified 

-- ProgramId of the application that produced this event	
case when substr(json_extract(events_persisted.payload,'$.data.TargetAppId'),1,1) is 'W' -- Windows Application x32/x64
	then upper(substr(json_extract(events_persisted.payload,'$.data.TargetAppId'),3,44 )) 
	end as 'Target AppId ProgramId',   -- Same as the 'ProgramId' in Amcache.hve (Root\InventoryApplicationFile\)	

-- Universal Windows Platform version info
case when substr(json_extract(events_persisted.payload,'$.data.TargetAppId'),1,1) is 'W'
	then substr(json_extract(events_persisted.payload,'$.data.TargetAppVer'),(instr(substr(json_extract(events_persisted.payload,'$.data.TargetAppVer'),22),'!')+22)) 
	else substr(json_extract(events_persisted.payload,'$.data.TargetAppVer'),(instr(substr(json_extract(events_persisted.payload,'$.data.TargetAppVer'),22),'!%!')))  
	end as 'TargetApp Ver',
	
	
-- Local, MS or AAD account 
trim(json_extract(events_persisted.payload,'$.ext.user.localId'),'m:') as 'UserId',
sid as 'User SID',

logging_binary_name

from events_persisted
where events_persisted.full_event_name like 'KernelProcess.AppStateChangeSummary%'

 -- Sort by event date dscending (newest first)
order by cast(events_persisted.timestamp as integer) desc