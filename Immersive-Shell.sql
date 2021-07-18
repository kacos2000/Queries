-- Diagnostic  'Microsoft-Windows-Immersive-Shell' (315A8872-923E-4EA2-9889-33CD4754BF64)
-- from C:\ProgramData\Microsoft\Diagnosis\EventTranscript\EventTranscript.db

SELECT

--Timestamp from db field
json_extract(events_persisted.payload,'$.time') as 'UTC TimeStamp',

-- Timestamp from json payload
datetime((timestamp - 116444736000000000)/10000000, 'unixepoch','localtime') as 'Local TimeStamp',
json_extract(events_persisted.payload,'$.ext.loc.tz') as 'TimeZome',
cast(json_extract(events_persisted.payload,'$.ext.utc.seq') as INTEGER) as 'seq', 

-- Event
replace(json_extract(events_persisted.payload,'$.data.SqmableContractID'),'Windows.','') as 'SqmableContractID',
json_extract(events_persisted.payload,'$.data.ExeName') as 'ExeName',
json_extract(events_persisted.payload,'$.data.AppID') as 'AppId',


-- Local, MS or AAD account 
json_extract(events_persisted.payload,'$.data.accountId') as 'accountId',
trim(json_extract(events_persisted.payload,'$.ext.user.localId'),'m:') as 'UserId',
sid as 'User SID',

logging_binary_name


from events_persisted
where events_persisted.full_event_name like '%315A8872-923E-4EA2-9889-33CD4754BF64.5901_1%'


 -- Sort by event date dscending (newest first)
order by cast(events_persisted.timestamp as integer) desc