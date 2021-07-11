-- Diagnostic Microsoft.WebBrowser
-- from C:\ProgramData\Microsoft\Diagnosis\EventTranscript\EventTranscript.db
-- For more info visit https://github.com/rathbuna/EventTranscript.db-Research


SELECT

--Timestamp from db field
json_extract(events_persisted.payload,'$.time') as 'UTC TimeStamp',
-- Timestamp from json payload
datetime((timestamp - 116444736000000000)/10000000, 'unixepoch','localtime') as 'Local TimeStamp',

json_extract(events_persisted.payload,'$.ext.utc.seq') as 'seq',
replace(replace(replace(events_persisted.full_event_name,'Microsoft-Windows-Desktop-Shell-Windowing.',''),'VirtualDesktop',''),'Microsoft.Windows.Shell.Switcher.','') as 'Event',
json_extract(events_persisted.payload,'$.ext.metadata.f.desktopId') as 'desktopId',
coalesce(json_extract(events_persisted.payload,'$.data.newDesktopId'),json_extract(events_persisted.payload,'$.data.desktopId')) as 'Current DesktopId',
json_extract(events_persisted.payload,'$.data.oldDesktopId') as 'Old DesktopId',
json_extract(events_persisted.payload,'$.data.destroyedDesktopId') as 'Destroyed DesktopId',
json_extract(events_persisted.payload,'$.data.fallbackDesktopId') as 'Fallback DesktopId',
case json_extract(events_persisted.payload,'$.data.isActiveDesktop') 
when 1 then 'Yes'
end as 'isActiveDesktop',

logging_binary_name,
-- user
trim(json_extract(events_persisted.payload,'$.ext.user.localId'),'m:') as 'UserId',
events_persisted.sid as 'User SID'


from events_persisted 
where events_persisted.full_event_name like ('%VirtualDesktop%')
order by events_persisted.timestamp desc