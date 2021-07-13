-- Diagnostic Microsoft.WebBrowser (Aria)
-- from C:\ProgramData\Microsoft\Diagnosis\EventTranscript\EventTranscript.db
-- For more info visit https://github.com/rathbuna/EventTranscript.db-Research


SELECT

--Timestamp from db field
json_extract(events_persisted.payload,'$.time') as 'UTC TimeStamp',
-- Timestamp from json payload
datetime((timestamp - 116444736000000000)/10000000, 'unixepoch','localtime') as 'Local TimeStamp',

json_extract(events_persisted.payload,'$.ext.utc.seq') as 'seq',

-- Event App & event description
json_extract(events_persisted.payload,'$.data.EventName') as 'EventName',
json_extract(events_persisted.payload,'$.ext.app.name') as 'app',
tag_descriptions.tag_name as 'Description', -- where you'll see these events in MS Diagnostic Data Viewer app
coalesce(json_extract(events_persisted.payload,'$.data.ShortEventName'),replace(replace(substr(distinct full_event_name,39),'Microsoft.',''),'WebBrowser.HistoryJournal.HJ_','')) as 'event',

-- Actions
json_extract(events_persisted.payload,'$.data.TabId') as 'Tab Id', -- (Note that apps like twitter use containerized (?) IE/Edge for navigation)
case 
	when json_extract(events_persisted.payload,'$.data.PageTitle') is NULL and json_extract(events_persisted.payload,'$.data.NoteLocalId') is not NULL
	then upper(json_extract(events_persisted.payload,'$.data.NoteLocalId')) -- get Sticky Notes local ID
	when json_extract(events_persisted.payload,'$.data.PageTitle') is NULL and json_extract(events_persisted.payload,'$.data.NoteLocalId') is NULL
	then coalesce(json_extract(events_persisted.payload,'$.data.DOMAnchorHrefUrl'),json_extract(events_persisted.payload,'$.data.referUrl')) 
	else json_extract(events_persisted.payload,'$.data.PageTitle') 
	end as 'PageTitle/Referrer',
coalesce(json_extract(events_persisted.payload,'$.data.navigationUrl'),json_extract(events_persisted.payload,'$.data.DSPCurrentUrl'))    as 'Url',

-- Tracking
upper(json_extract(events_persisted.payload,'$.data.CorrelationGuid')) as 'Correlation Guid', 
upper(json_extract(events_persisted.payload,'$.data."Session.EcsETag"')) as 'Session Tag (Base64)', -- Sticky Notes session 
logging_binary_name,

-- Net info
coalesce(json_extract(events_persisted.payload,'$.ext.net.type'),json_extract(events_persisted.payload,'$.data.ConnectionType')) as 'type',
json_extract(events_persisted.payload,'$.ext.net.cost') as 'cost',

-- Local, MS or AAD account 
trim(json_extract(events_persisted.payload,'$.ext.user.localId'),'m:') as 'UserId',
sid as 'User SID'


from events_persisted 
join event_tags on events_persisted.full_event_name_hash = event_tags.full_event_name_hash
join tag_descriptions on event_tags.tag_id = tag_descriptions.tag_id 

where 
events_persisted.full_event_name like 'Aria.%'and (
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
events_persisted.full_event_name not like '%15cbbc93e90a4d56bf8d9a29305b8981%' and -- exclude Sticky Notes
tag_descriptions.tag_name not like '%Device Connectivity and Configuration%' and 
tag_descriptions.tag_name not like '%Performance%' )



 -- Sort by event sequence number descending (newest first)
order by cast(seq as integer) desc