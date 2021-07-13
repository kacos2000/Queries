-- Diagnostic DxgKrnlTelemetry.ClientRunningTime
-- from C:\ProgramData\Microsoft\Diagnosis\EventTranscript\EventTranscript.db


SELECT

--Timestamp from db field
json_extract(events_persisted.payload,'$.time') as 'UTC TimeStamp',

-- Timestamp from json payload
datetime((timestamp - 116444736000000000)/10000000, 'unixepoch','localtime') as 'Local TimeStamp',
json_extract(events_persisted.payload,'$.ext.loc.tz') as 'TimeZome',
json_extract(events_persisted.payload,'$.ext.utc.seq') as 'seq', 


-- Events
json_extract(events_persisted.payload,'$.data.ProcessId') as 'Event Id',
json_extract(events_persisted.payload,'$.data.ProcessName') as 'Process Name',
--json_extract(events_persisted.payload,'$.ext.app.id') as 'App Id Name',

-- Application Type
case substr(json_extract(events_persisted.payload,'$.ext.app.id'),1,1) 
	when 'W' then 'Win' -- Windows Application x32/x64
	when 'U' then 'UWP' -- Universal Windows App (UWP)
	end as 'Type',	
	
-- Application Name
case when substr(json_extract(events_persisted.payload,'$.ext.app.id'),1,1) is 'W' -- Windows Application x32/x64
	then substr(json_extract(events_persisted.payload,'$.ext.app.id'),93) 
	else substr(json_extract(events_persisted.payload,'$.ext.app.id'),3)
	end as 'Executable',	

json_extract(events_persisted.payload,'$.data.VmProcessName') as 'VM Process Name',
json_extract(events_persisted.payload,'$.data.Client') as 'Client',
time(json_extract(events_persisted.payload,'$.data.RunningTime100ns')/10000,'unixepoch')||" ("||json_extract(events_persisted.payload,'$.data.RunningTime100ns')||")" as 'RunningTime (100ns)',

-- Process type (if set)
case json_extract(events_persisted.payload,'$.data.IsLinuxProcess')
	when 0 then 'No'
	when 1 then 'Yes'
	end as 'IsLinuxProcess',
case json_extract(events_persisted.payload,'$.data.IsVmProcess')
	when 0 then 'No'
	when 1 then 'Yes'
	end as 'IsVmProcess',
case json_extract(events_persisted.payload,'$.data.IsWslProcess')
	when 0 then 'No'
	when 1 then 'Yes'
	end as 'IsWslProcess',
	
-- SHA1 Hash of the application that produced this event	
case when substr(json_extract(events_persisted.payload,'$.ext.app.id'),1,1) is 'W' -- Windows Application x32/x64
	then upper(substr(json_extract(events_persisted.payload,'$.ext.app.id'),52,44 ))
	-- Same as the 'FileId' in Amcache.hve (Root\InventoryApplicationFile\)
	end as 'SHA1',	-- (SHA1 Base16) checked & verified 

-- Version of the application that produced this event	
case when substr(json_extract(events_persisted.payload,'$.ext.app.id'),1,1) is 'W' -- Windows Application x32/x64
	then upper(substr(json_extract(events_persisted.payload,'$.ext.app.id'),3,44 )) 
	end as 'ProgramId',   --  -- Same as the 'ProgramId' in Amcache.hve (Root\InventoryApplicationFile\)	

-- Tracking
json_extract(events_persisted.payload,'$.data.AppSessionGuid') as 'AppSession Guid',	

-- InterfaceId info
json_extract(events_persisted.payload,'$.data.InterfaceId') as 'Interface Id'

from events_persisted
where events_persisted.full_event_name like '%DxgKrnlTelemetry.ClientRunningTime%'

 -- Sort by event datedescending (newest first)
order by cast(events_persisted.timestamp as integer) desc