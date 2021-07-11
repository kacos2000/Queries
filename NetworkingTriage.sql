-- Diagnostic 
--		Microsoft.OneCore.NetworkingTriage
--      Microsoft.Windows.Networking.DHCP
--      Microsoft.Windows.Networking.DNS
--      Microsoft.Windows.Networking.NetworkSetupSvc
--
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
replace(replace(replace(replace(replace(replace(full_event_name,'Microsoft.OneCore.NetworkingTriage.GetConnected.',''),'Microsoft.Windows.Networking.DHCP.',''),'Microsoft.Windows.Networking.DHCPv6.',''),'Microsoft.Windows.Networking.DNS.',''),'Microsoft.Windows.Networking.SharedAccess.',''),'Microsoft.Windows.Networking.NetworkSetupSvc.','') as 'Event',
json_extract(events_persisted.payload,'$.data.eventSource') as 'Event Source',
coalesce(json_extract(events_persisted.payload,'$.data.reason'),json_extract(events_persisted.payload,'$.data.eventSource')) as 'Event Reason',
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
json_extract(events_persisted.payload,'$.data.NextHop') as 'NextHop', -- usually the Router IP
json_extract(events_persisted.payload,'$.data.AssignedAddress') as 'AssignedAddress',
json_extract(events_persisted.payload,'$.data.Dest') as 'Dest',
json_extract(events_persisted.payload,'$.data.DestMask') as 'DestMask',

-- DNS Servers
json_extract(events_persisted.payload,'$.data.DnsServers') as 'DnsServers',

-- Tracking:

-- Local Interface name
json_extract(events_persisted.payload,'$.data.interfaceDescription') as 'Interface',
json_extract(events_persisted.payload,'$.data.interfaceGuid') as 'interfaceGuid',
json_extract(events_persisted.payload,'$.data.SessionTrackingGuid') as 'Session',

-- InstallPnPDevice
json_extract(events_persisted.payload,'$.data.driverDesc') as 'driverDesc',
json_extract(events_persisted.payload,'$.data.pnpId') as 'pnpId',
json_extract(events_persisted.payload,'$.data.providerName') as 'providerName',
json_extract(events_persisted.payload,'$.data.mediaType') as 'mediaType',
json_extract(events_persisted.payload,'$.data.physicalMediaType') as 'physicalMediaType',


-- Local, MS or AAD account 
trim(json_extract(events_persisted.payload,'$.ext.user.localId'),'m:') as 'UserId',
sid as 'User SID',

logging_binary_name


from events_persisted 
where 
-- include events:
  (events_persisted.full_event_name like 'Microsoft.OneCore.NetworkingTriage.%' 
or events_persisted.full_event_name like 'Microsoft.Windows.Networking.SharedAccess.%' -- DHCP assigned IP
or events_persisted.full_event_name like 'Microsoft.Windows.Networking.DHCP%' -- change to "DHCP." to skip DHCPv6 
or events_persisted.full_event_name like 'Microsoft.Windows.Networking.DNS.DnsServerConfig.%'
or events_persisted.full_event_name like 'Microsoft.Windows.Networking.NetworkSetupSvc.InstallPnPDevice%'
or events_persisted.full_event_name like 'Microsoft.Windows.Networking.NetworkSetupSvc.ForeignNetworkInterface%')

-- excluse event list:
and events_persisted.full_event_name not like '%DiscoveryAttempt%'
and events_persisted.full_event_name not like '%MediaConnected%'
and events_persisted.full_event_name not like '%DhcpSetEventInRenewState%'
and events_persisted.full_event_name not like '%SolicitAttempt%'
and events_persisted.full_event_name not like '%InterfaceCapabilityChangedEvent%'
-- Sort by date descending (newest first)
order by events_persisted.timestamp desc