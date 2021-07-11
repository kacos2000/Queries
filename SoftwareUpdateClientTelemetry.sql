-- Diagnostic SoftwareUpdateClientTelemetry
-- from C:\ProgramData\Microsoft\Diagnosis\EventTranscript\EventTranscript.db
-- For more info visit https://github.com/rathbuna/EventTranscript.db-Research

SELECT

-- Timestamp from db field
json_extract(events_persisted.payload,'$.time') as 'UTC TimeStamp',
-- Timestamp from json payload
datetime((timestamp - 116444736000000000)/10000000, 'unixepoch','localtime') as 'Local TimeStamp',
producers.producer_id_text as Producer,

json_extract(events_persisted.payload,'$.ext.utc.seq') as 'seq',
-- Actions
replace(full_event_name,'SoftwareUpdateClientTelemetry.','') as 'Event',
json_extract(events_persisted.payload,'$.data.EventScenario') as 'Status',
json_extract(events_persisted.payload,'$.data.CallerApplicationName') as 'CallerApplicationName',
json_extract(events_persisted.payload,'$.data.NumberOfApplicableUpdates') as 'NrOfApplicableUpdates',
json_extract(events_persisted.payload,'$.data.IntentPFNs') as 'IntentPFNs',
coalesce(json_extract(events_persisted.payload,'$.data.HostName'),json_extract(events_persisted.payload,'$.data.ServiceUrl')) as 'HostName',
json_extract(events_persisted.payload,'$.data.EventInstanceID') as 'EventInstanceID',
json_extract(events_persisted.payload,'$.ext.utc.pgName') as 'pgName',
json_extract(events_persisted.payload,'$.ext.utc.loggingBinary') as 'loggingBinary',

json_extract(events_persisted.payload,'$.data.EventScenario') as 'Status',

-- user
json_extract(events_persisted.payload,'$.data.ApplicableUpdateInfo') as 'ApplicableUpdateInfo',
events_persisted.sid as 'User SID'

FROM events_persisted
join producers on producers.producer_id = events_persisted.producer_id
join event_tags on events_persisted.full_event_name_hash = event_tags.full_event_name_hash
where full_event_name like '%SoftwareUpdateClientTelemetry%'
order by events_persisted.timestamp desc