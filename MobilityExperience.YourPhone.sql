-- Diagnostic Microsoft.Windows.MobilityExperience.YourPhone
-- from C:\ProgramData\Microsoft\Diagnosis\EventTranscript\EventTranscript.db
-- For more info visit https://github.com/rathbuna/EventTranscript.db-Research


select

--Timestamp from db field
json_extract(events_persisted.payload,'$.time') as 'UTC TimeStamp',
-- Timestamp from json payload
datetime((timestamp - 116444736000000000)/10000000, 'unixepoch','localtime') as 'Local TimeStamp',
json_extract(events_persisted.payload,'$.ext.utc.seq') as 'seq',
-- Actions
replace(replace(events_persisted.full_event_name,'Microsoft.Windows.MobilityExperience.YourPhone.',''),'YPP.','') as 'Event',
replace(replace(json_extract(events_persisted.payload,'$.data.traceState'),'ypScenarioId=',''),',ypTriggerId=',': ') as 'traceState', 
coalesce(json_extract(events_persisted.payload,'$.data.activityStatus'),json_extract(events_persisted.payload,'$.data.contentType')) as 'activityStatus',

json_extract(events_persisted.payload,'$.data.name') as 'Activity',
json_extract(events_persisted.payload,'$.data.resultDetail') as 'Result',
json_extract(events_persisted.payload,'$.data.totalBytes') as 'TotalBytes',

-- Phone Status

   -- for some reason json_extract can't extract this JSON blob which has linked Phone status info 
   -- so this line extracts the blob as text
json_extract(events_persisted.payload,'$.data.details') as 'Details', 

-- YourPhone app version
replace(json_extract(events_persisted.payload,'$.ext.app.id'),'U:','') as 'YourPhone id',
   -- for some reason json_extract can't extract this JSON blob which has linked Phone info 
   -- so this line extracts the blob as text:
json_extract(events_persisted.payload,'$.data.linkedDevice') as 'linkedDevice',
   -- similar to the 'flightRing' info from the above Blob:
json_extract(events_persisted.payload,'$.data.ringName') as 'ringName', -- YourPhone app Public or Beta/Preview type


-- Tracking
json_extract(events_persisted.payload,'$.data.correlationId') as 'correlationId',
json_extract(events_persisted.payload,'$.data.notificationId') as 'notificationId',
case json_extract(events_persisted.payload,'$.data.isNew') 
	when 1 then 'Yes'
	end as 'isNew',

-- user
trim(json_extract(events_persisted.payload,'$.ext.user.localId'),'m:') as 'UserId',
events_persisted.sid as 'User SID'

from events_persisted 
where events_persisted.full_event_name like 'Microsoft.Windows.MobilityExperience.YourPhone.%'
and events_persisted.full_event_name not like 'Microsoft.Windows.MobilityExperience.YourPhone.ExpResponseDetails%'
and events_persisted.full_event_name not like 'Microsoft.Windows.MobilityExperience.YourPhone.Task%'  
and events_persisted.full_event_name not like 'Microsoft.Windows.MobilityExperience.YourPhone.Cdm%'   -- Content delivery diagnostics
and events_persisted.full_event_name not like 'Microsoft.Windows.MobilityExperience.YourPhone.FullTrustServerCreateFactory%' -- Before sent message
and events_persisted.full_event_name not like 'Microsoft.Windows.MobilityExperience.YourPhone.AppServiceCanceled%'           -- After sent message


 -- Sort by event datedescending (newest first)
order by cast(events_persisted.timestamp as integer) desc