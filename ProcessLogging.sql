-- Diagnostic DMicrosoft.Windows.Compatibility.Encapsulation
--      ProcessLoggingFile
--      ProcessLoggingRegistry
-- from C:\ProgramData\Microsoft\Diagnosis\EventTranscript\EventTranscript.db

SELECT

--Timestamp from db field
json_extract(events_persisted.payload,'$.time') as 'UTC TimeStamp',

-- Timestamp from json payload
datetime((timestamp - 116444736000000000)/10000000, 'unixepoch','localtime') as 'Local TimeStamp',
json_extract(events_persisted.payload,'$.ext.loc.tz') as 'TimeZome',
json_extract(events_persisted.payload,'$.ext.utc.seq') as 'seq', 

-- Evrnt
replace( events_persisted.full_event_name,'Microsoft.Windows.Compatibility.Encapsulation.','') as 'Event',

json_extract(events_persisted.payload,'$.data.ExeName') as 'ExeName',
json_extract(events_persisted.payload,'$.data.IsInstaller') as 'IsInstaller',
upper(json_extract(events_persisted.payload,'$.data.ProgramId')) as 'ProgramId',
json_extract(events_persisted.payload,'$.data.pathOps') as 'pathOps',


-- Local, MS or AAD account 
trim(json_extract(events_persisted.payload,'$.ext.user.localId'),'m:') as 'UserId',
sid as 'User SID',

logging_binary_name

from events_persisted
where events_persisted.full_event_name like 'Microsoft.Windows.Compatibility.Encapsulation.%'
and events_persisted.full_event_name not like '%Api%'

 -- Sort by event date dscending (newest first)
order by cast(events_persisted.timestamp as integer) desc