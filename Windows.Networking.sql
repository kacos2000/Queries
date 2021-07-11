-- Diagnostic Microsoft.Windows.Networking (only). Use:
-- https://github.com/kacos2000/Queries/blob/master/NetworkingTriage.sql
-- for a more network history.
-- 
-- Database location:
-- C:\ProgramData\Microsoft\Diagnosis\EventTranscript\EventTranscript.db
-- For more info visit https://github.com/rathbuna/EventTranscript.db-Research

SELECT

--Timestamp from db field
json_extract(events_persisted.payload,'$.time') as 'UTC TimeStamp',
-- Timestamp from json payload
datetime((timestamp - 116444736000000000)/10000000, 'unixepoch','localtime') as 'Local TimeStamp',
json_extract(events_persisted.payload,'$.ext.loc.tz') as 'TimeZome',
json_extract(events_persisted.payload,'$.ext.utc.seq') as 'seq',

-- events
replace(replace(replace(replace(replace(replace(full_event_name,'Microsoft.Windows.Networking.',''),'DHCP.',''),'DHCPv6.',''),'DNS.',''),'SharedAccess.',''),'NetworkSetupSvc.','') as 'Event',

-- DHCP
json_extract(events_persisted.payload,'$.data.DhcpMode') as 'DhcpMode', 
case json_extract(events_persisted.payload,'$.data.GotOffer') 
	when 0 then 'No'
	when 1 then 'Yes'
	else json_extract(events_persisted.payload,'$.data.GotOffer')
	end as 'GotOffer', 
case json_extract(events_persisted.payload,'$.data.DisableDhcpSet') 
	when 0 then 'No'
	when 1 then 'Yes'
	end as 'DisableDhcpSet', 	
case json_extract(events_persisted.payload,'$.data.DhcpIsInitState') 
	when 0 then 'No'
	when 1 then 'Yes'
	else json_extract(events_persisted.payload,'$.data.DhcpIsInitState')
	end as 'DhcpIsInitState', 

case json_extract(events_persisted.payload,'$.data.DhcpGlobalUseNetworkHint') 
	when 0 then 'No'
	when 1 then 'Yes'
	end as 'DhcpGlobalUseNetworkHint', 
	case json_extract(events_persisted.payload,'$.data.LeaseObtained')
		when 0 then 'No'
		else time(json_extract(events_persisted.payload,'$.data.LeaseObtained'),'unixepoch')
		end as 'LeaseObtained', -- in seconds
time(json_extract(events_persisted.payload,'$.data.LeaseTime'),'unixepoch') as 'LeaseTime', -- in seconds (converted to HH:MM:SS)
time(json_extract(events_persisted.payload,'$.data.LeaseDuration'),'unixepoch') as 'LeaseDuration', -- in seconds (converted to HH:MM:SS)
time(json_extract(events_persisted.payload,'$.data.LeaseExpires'),'unixepoch') as 'LeaseExpires', -- in seconds (converted to HH:MM:SS)
json_extract(events_persisted.payload,'$.data.NextHop') as 'NextHop', -- usually the Router IP
json_extract(events_persisted.payload,'$.data.AssignedAddress') as 'AssignedAddress',
json_extract(events_persisted.payload,'$.data.Dest') as 'Dest',
json_extract(events_persisted.payload,'$.data.DestMask') as 'DestMask',

-- DNS Servers
json_extract(events_persisted.payload,'$.data.DnsServers') as 'DnsServers',

-- InstallPnPDevice
json_extract(events_persisted.payload,'$.data.driverDesc') as 'driverDesc',
json_extract(events_persisted.payload,'$.data.pnpId') as 'pnpId',
json_extract(events_persisted.payload,'$.data.providerName') as 'providerName',
json_extract(events_persisted.payload,'$.data.mediaType') as 'mediaType',
json_extract(events_persisted.payload,'$.data.physicalMediaType') as 'physicalMediaType',

-- Tracking
json_extract(events_persisted.payload,'$.data.InterfaceGuid') as 'Interface',
json_extract(events_persisted.payload,'$.data.SessionTrackingGuid') as 'Session',


logging_binary_name


from events_persisted 
-- include events:
where events_persisted.full_event_name like 'Microsoft.Windows.Networking.%'
-- excluse event list:
and events_persisted.full_event_name not like '%DiscoveryAttempt%'
and events_persisted.full_event_name not like '%MediaConnected%'
and events_persisted.full_event_name not like '%SolicitAttempt%'
and events_persisted.full_event_name not like '%BFE.%'
and events_persisted.full_event_name not like '%WFP.%'
and events_persisted.full_event_name not like '%EDP.%'
and events_persisted.full_event_name not like '%AllDnsServersTimeoutStatistics%'
and events_persisted.full_event_name not like '%DnsServerFailureStats%'
and events_persisted.full_event_name not like '%DnsServerStatistics%'
and events_persisted.full_event_name not like '%DnsQueryStats%'
and events_persisted.full_event_name not like '%DhcpSetEventInRenewState%'
and events_persisted.full_event_name not like '%InterfaceCapabilityChangedEvent%'
-- Sort by date descending (newest first)
order by events_persisted.timestamp desc