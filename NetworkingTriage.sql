-- Diagnostic Microsoft.OneCore.NetworkingTriage
-- from C:\ProgramData\Microsoft\Diagnosis\EventTranscript\EventTranscript.db
-- For more info visit https://github.com/rathbuna/EventTranscript.db-Research

SELECT

--Timestamp from db field
json_extract(events_persisted.payload,'$.time') as 'UTC TimeStamp',
-- Timestamp from json payload
datetime((timestamp - 116444736000000000)/10000000, 'unixepoch','localtime') as 'Local TimeStamp',
json_extract(events_persisted.payload,'$.ext.loc.tz') as 'TimeZome',
json_extract(events_persisted.payload,'$.ext.utc.seq') as 'seq',

-- events
replace(full_event_name,'Microsoft.OneCore.NetworkingTriage.GetConnected.','') as 'Event',
json_extract(events_persisted.payload,'$.data.eventSource') as 'Event Source',
coalesce(json_extract(events_persisted.payload,'$.data.reason'),json_extract(events_persisted.payload,'$.data.eventSource')) as 'Reason',
json_extract(events_persisted.payload,'$.data.previousReason') as 'Rrevious Reason',
json_extract(events_persisted.payload,'$.data.nextHopAddress') as 'nextHopAddress',

-- Info
coalesce(json_extract(events_persisted.payload,'$.data.apPhyType'),json_extract(events_persisted.payload,'$.data.family')) as 'Type',
case 
	when json_extract(events_persisted.payload,'$.data.interfaceType') in (null,'Other') and json_extract(events_persisted.payload,'$.data.selectedIconAltText') is null and json_extract(events_persisted.payload,'$.data.mode') is null
	then json_extract(events_persisted.payload,'$.data.launchType')
	when json_extract(events_persisted.payload,'$.data.interfaceType') in (null,'Other') and json_extract(events_persisted.payload,'$.data.selectedIconAltText') is null 
	then json_extract(events_persisted.payload,'$.data.mode')
	else json_extract(events_persisted.payload,'$.data.interfaceType')
	end  as 'interfaceType',
	
-- Network Profile
json_extract(events_persisted.payload,'$.data.profileName') as 'profileName',
coalesce(json_extract(events_persisted.payload,'$.data.selectedIconAltText'),json_extract(events_persisted.payload,'$.data.networkStatus')) as 'Icon/Status',
json_extract(events_persisted.payload,'$.data.networkCategory') as 'networkCategory',
	
-- WiFi AccessPoint info
-- json_extract(events_persisted.payload,'$.data.apDescription') as 'Access Point Name', -- Not really needed here
json_extract(events_persisted.payload,'$.data.apManufacturer') as 'apManufacturer',
json_extract(events_persisted.payload,'$.data.apModelName') as 'apModelName',
json_extract(events_persisted.payload,'$.data.apModelNum') as 'apModelNum',

json_extract(events_persisted.payload,'$.data.cipherAlgo') as 'EncrType',

-- Access Point MAC
json_extract(events_persisted.payload,'$.data.bssid') as 'bssid',
json_extract(events_persisted.payload,'$.data.firstBSSID') as 'firstBSSID',

-- Local Interface name
json_extract(events_persisted.payload,'$.data.interfaceDescription') as 'Interface',
json_extract(events_persisted.payload,'$.data.interfaceGuid') as 'interfaceGuid',

-- Local, MS or AAD account 
trim(json_extract(events_persisted.payload,'$.ext.user.localId'),'m:') as 'UserId',
sid as 'User SID',

logging_binary_name


from events_persisted 
where events_persisted.full_event_name like 'Microsoft.OneCore.NetworkingTriage.%'
order by events_persisted.timestamp desc