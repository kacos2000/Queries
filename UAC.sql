-- Diagnostic  Windows User Account Controls (UAC), formerly known as Limited User Account (LUA)
-- from        93C05D69-51A3-485E-877F-1806A8731346.16001_0
-- and         Microsoft.Windows.Security.LUA.ConsentUILaunched
-- from C:\ProgramData\Microsoft\Diagnosis\EventTranscript\EventTranscript.db

SELECT

--Timestamp from db field
json_extract(events_persisted.payload,'$.time') as 'UTC TimeStamp',

-- Timestamp from json payload
datetime((timestamp - 116444736000000000)/10000000, 'unixepoch','localtime') as 'Local TimeStamp',
json_extract(events_persisted.payload,'$.ext.loc.tz') as 'TimeZome',
cast(json_extract(events_persisted.payload,'$.ext.utc.seq') as INTEGER) as 'seq', 

-- Event
json_extract(events_persisted.payload,'$.data.EventId') as 'EventId',
json_extract(events_persisted.payload,'$.data.friendlyName') as 'friendlyName',
coalesce(json_extract(events_persisted.payload,'$.data.UACElevateFileID'),json_extract(events_persisted.payload,'$.data.exeName')) as 'UACElevateFileID',
json_extract(events_persisted.payload,'$.data.publisherName') as 'publisherName',
-- https://gist.github.com/Elm0D/de94d428ef8c45b7cd24409b5c343a33
json_extract(events_persisted.payload,'$.data.cmdLine') as 'cmdLine',
-- List of COM objects with enabled elevation:
-- https://docs.microsoft.com/en-us/dotnet/api/java.security.signaturestate?view=xamarin-android-sdk-9
case json_extract(events_persisted.payload,'$.data.signatureState') 
	when 0 then 'Unchecked'
	when 1 then 'Unsigned' -- ??
	when 2 then 'Sign'
	when 3 then 'Verify'
	else json_extract(events_persisted.payload,'$.data.signatureState') 
	end as 'signatureState',
json_extract(events_persisted.payload,'$.data.elevationReason') as 'elevationReason',
json_extract(events_persisted.payload,'$.data.eventType') as 'eventType',

-- Local, MS or AAD account 
trim(json_extract(events_persisted.payload,'$.ext.user.localId'),'m:') as 'UserId',
sid as 'User SID',

logging_binary_name


from events_persisted
where events_persisted.full_event_name like '%93C05D69-51A3-485E-877F-1806A8731346.16001_0%' or
events_persisted.full_event_name like 'Microsoft.Windows.Security.LUA.ConsentUILaunched%'


 -- Sort by event date dscending (newest first)
order by cast(events_persisted.timestamp as integer) desc