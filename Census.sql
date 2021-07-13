-- Diagnostic Census (devicecensus.exe)
--
-- from C:\ProgramData\Microsoft\Diagnosis\EventTranscript\EventTranscript.db
-- For more info visit https://github.com/rathbuna/EventTranscript.db-Research
-- and "Forensically Unpacking EventTranscript.db: An Investigative Series" at
-- https://www.kroll.com/en/insights/publications/cyber/forensically-unpacking-eventtranscript
--
-- Census.PrivacySettings:
-- https://docs.microsoft.com/en-us/windows/privacy/basic-level-windows-diagnostic-events-and-fields-1809#censusprivacysettings

SELECT

--Timestamp from db field
json_extract(events_persisted.payload,'$.time') as 'UTC TimeStamp',
-- Timestamp from json payload
datetime((timestamp - 116444736000000000)/10000000, 'unixepoch','localtime') as 'Local TimeStamp',
json_extract(events_persisted.payload,'$.ext.loc.tz') as 'TimeZome',
json_extract(events_persisted.payload,'$.ext.utc.seq') as 'seq',

-- events
replace(events_persisted.full_event_name,'Census.','') as 'Event',
--replace(json_extract(events_persisted.payload,'$.name'),'Census.','') as 'Name',

-- Current state / Settings
json_extract(events_persisted.payload,'$.data') as 'State \ Settings',


-- Local, MS or AAD account 
trim(json_extract(events_persisted.payload,'$.ext.user.localId'),'m:') as 'UserId',
sid as 'User SID',

logging_binary_name


from events_persisted 
where 
-- include events:
  events_persisted.full_event_name like 'Census%' 

  
 -- Sort by event sequence number descending (newest first)
order by cast(seq as integer) desc