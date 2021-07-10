-- Diagnostic ClipboardHistory
-- from C:\ProgramData\Microsoft\Diagnosis\EventTranscript\EventTranscript.db

SELECT
--Timestamp from db field
json_extract(events_persisted.payload,'$.time') as 'Time',
-- Timestamp from json payload
datetime((timestamp - 116444736000000000)/10000000, 'unixepoch') as 'Payload UTC TimeStamp',
json_extract(events_persisted.payload,'$.ext.loc.tz') as 'TimeZome',
json_extract(events_persisted.payload,'$.data.Origin') as 'Origin',


json_extract(events_persisted.payload,'$.data.IsCurrentClipboardData') as 'IsCurrent',
producers.producer_id_text as 'Producer',
json_extract(events_persisted.payload,'$.data.SourceApplicationName') as 'SourceApplicationName',
json_extract(events_persisted.payload,'$.data.ItemDataCreationStatus') as 'CreationStatus',
-- JSON of copied items info
json_extract(events_persisted.payload,'$.data.Formats') as 'Formats',
compressed_payload_size as 'size',

-- Local, MS or AAD account 
json_extract(events_persisted.payload,'$.ext.user.localId') as 'UserId',
-- OS
json_extract(events_persisted.payload,'$.ext.os.name') as 'OS',
-- Device class (same as the type used in ActivitiesCache.db
json_extract(events_persisted.payload,'$.ext.device.deviceClass') as 'deviceClass',
json_extract(events_persisted.payload,'$.ext.device.localId') as 'localId',
-- Appears to link clipboard events
json_extract(events_persisted.payload,'$.ext.protocol.ticketKeys') as 'ticketKeys',
-- Device info from registry
json_extract(events_persisted.payload,'$.ext.protocol.devMake') as 'Device Make',
json_extract(events_persisted.payload,'$.ext.protocol.devModel') as 'Device Model',
logging_binary_name

from events_persisted 
join producers on events_persisted.producer_id = producers.producer_id
where full_event_name is 'Microsoft.Windows.ClipboardHistory.Service.AddItemActivity' 
order by timestamp desc


