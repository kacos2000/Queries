-- Diagnostic  Windows User Account Controls (UAC), formerly known as Limited User Account (LUA)
--             (93C05D69-51A3-485E-877F-1806A8731346)
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
json_extract(events_persisted.payload,'$.data.UACElevateFileID') as 'UACElevateFileID',

json_extract(events_persisted.payload,'$.data.EventId') as 'EventId',

-- Local, MS or AAD account 
trim(json_extract(events_persisted.payload,'$.ext.user.localId'),'m:') as 'UserId',
sid as 'User SID',

logging_binary_name


from events_persisted
where events_persisted.full_event_name like '%93C05D69-51A3-485E-877F-1806A8731346.16001_0%'


 -- Sort by event date dscending (newest first)
order by cast(events_persisted.timestamp as integer) desc