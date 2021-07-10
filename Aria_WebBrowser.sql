-- Diagnostic Microsoft.WebBrowser
-- from C:\ProgramData\Microsoft\Diagnosis\EventTranscript\EventTranscript.db
-- For more info visit https://github.com/rathbuna/EventTranscript.db-Research


SELECT

--Timestamp from db field
json_extract(events_persisted.payload,'$.time') as 'UTC TimeStamp',
-- Timestamp from json payload
datetime((timestamp - 116444736000000000)/10000000, 'unixepoch','localtime') as 'Local TimeStamp',

-- Actions
coalesce(json_extract(events_persisted.payload,'$.data.ShortEventName'),replace(replace(substr(distinct full_event_name,39),'Microsoft.',''),'WebBrowser.HistoryJournal.HJ_','')) as 'event',
json_extract(events_persisted.payload,'$.ext.utc.seq') as 'seq',
json_extract(events_persisted.payload,'$.data.TabId') as 'TabId',
coalesce(json_extract(events_persisted.payload,'$.data.PageTitle'),    json_extract(events_persisted.payload,'$.data.DOMAnchorHrefUrl')) as 'PageTitle/RefUrl',
coalesce(json_extract(events_persisted.payload,'$.data.navigationUrl'),json_extract(events_persisted.payload,'$.data.DSPCurrentUrl'))    as 'Url',
json_extract(events_persisted.payload,'$.data.actionName') as 'actionName',
coalesce(json_extract(events_persisted.payload,'$.ext.net.type'),json_extract(events_persisted.payload,'$.data.ConnectionType')) as 'type',
json_extract(events_persisted.payload,'$.ext.net.cost') as 'cost',
json_extract(events_persisted.payload,'$.ext.app.name') as 'app',
logging_binary_name

from events_persisted 
where 
events_persisted.full_event_name like ('Aria.%') and 
events_persisted.full_event_name not like '%HeartBeat' and 
events_persisted.full_event_name not like '%Timing%'   and 
events_persisted.full_event_name not like '%EdgeUpdate%' and 
events_persisted.full_event_name not like '%Protobuf%' and 
events_persisted.full_event_name not like '%Extended%' and 
events_persisted.full_event_name not like '%Trace%' and 
events_persisted.full_event_name not like '%qossync%' and 
events_persisted.full_event_name not like '%ScopedCriticalTask%' and 
events_persisted.full_event_name not like '%Actor%' and 
events_persisted.full_event_name not like '%SessionIdCorrelation%' and 
events_persisted.full_event_name not like '%ScopedCriticalTask%' and 
events_persisted.full_event_name not like '%Assert%' and 
events_persisted.full_event_name not like '%BrowserInfo%' and 
events_persisted.full_event_name not like '%diagnosticssync%' 
order by events_persisted.timestamp desc