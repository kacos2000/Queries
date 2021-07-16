-- Diagnostic  'Microsoft.Windows.Inventory.Core'
-- from C:\ProgramData\Microsoft\Diagnosis\EventTranscript\EventTranscript.db

SELECT

--Timestamp from db field
json_extract(events_persisted.payload,'$.time') as 'UTC TimeStamp',

-- Timestamp from json payload
datetime((timestamp - 116444736000000000)/10000000, 'unixepoch','localtime') as 'Local TimeStamp',
json_extract(events_persisted.payload,'$.ext.loc.tz') as 'TimeZome',
json_extract(events_persisted.payload,'$.ext.utc.seq') as 'seq', 

-- Event
replace(events_persisted.full_event_name,'Microsoft.Windows.Inventory.Core.Inventory','') as 'InputSession',

-- info
coalesce(json_extract(events_persisted.payload,'$.data.Type'),json_extract(events_persisted.payload,'$.data.Class')) as 'Type/Class',
coalesce(json_extract(events_persisted.payload,'$.data.Name'),json_extract(events_persisted.payload,'$.data.DriverName'),json_extract(events_persisted.payload,'$.data.ModelName')) as 'Name',
coalesce(json_extract(events_persisted.payload,'$.data.Service'),json_extract(events_persisted.payload,'$.data.PrimaryCategory')) as 'Service/Category',

-- Container type
case json_extract(events_persisted.payload,'$.data.IsActive')
	when '0' then 'No'
	when '1' then 'Yes'
	else json_extract(events_persisted.payload,'$.data.IsActive')
	end as 'Active',

case json_extract(events_persisted.payload,'$.data.IsConnected')
	when '0' then 'No'
	when '1' then 'Yes'
	else json_extract(events_persisted.payload,'$.data.IsConnected')
	end as 'Connected',
	
case json_extract(events_persisted.payload,'$.data.IsMachineContainer')
	when '0' then 'No'
	when '1' then 'Yes'
	else json_extract(events_persisted.payload,'$.data.IsMachineContainer')
	end as 'IsMachine',	
	
case json_extract(events_persisted.payload,'$.data.IsNetworked')
	when '0' then 'No'
	when '1' then 'Yes'
	else json_extract(events_persisted.payload,'$.data.IsNetworked')
	end as 'Networked',		
	
-- Version
json_extract(events_persisted.payload,'$.data.Version') as 'Version',
json_extract(events_persisted.payload,'$.data.DriverVerDate') as 'DriverVerDate',
json_extract(events_persisted.payload,'$.data.Provider') as 'Provider',
json_extract(events_persisted.payload,'$.data.Manufacturer') as 'Manufacturer',
json_extract(events_persisted.payload,'$.data.Model') as 'Model',

-- Path
coalesce(json_extract(events_persisted.payload,'$.data.RootDirPath'),json_extract(events_persisted.payload,'$.data.ParentId')) as 'Parent',
json_extract(events_persisted.payload,'$.data.HiddenArp') as 'Hidden',

-- Install info
json_extract(events_persisted.payload,'$.data.InstallDate') as 'InstallDate',
json_extract(events_persisted.payload,'$.data.InstallState') as 'InstallState',
json_extract(events_persisted.payload,'$.data.FirstInstallDate') as 'FirstInstall',
json_extract(events_persisted.payload,'$.data.Source') as 'Source',


-- MSI Installer specific
json_extract(events_persisted.payload,'$.data.MsiInstallDate') as 'MsiInstallDate',
json_extract(events_persisted.payload,'$.data.MsiPackageCode') as 'MsiPackageCode',
json_extract(events_persisted.payload,'$.data.MsiProductCode') as 'MsiProductCode',

-- Device
json_extract(events_persisted.payload,'$.data.BusReportedDescription') as 'BusDescription',
json_extract(events_persisted.payload,'$.data.Description') as 'Description',
json_extract(events_persisted.payload,'$.data.Enumerator') as 'Enumerator',

case json_extract(events_persisted.payload,'$.data.COMPID')
	when '[]' then json_extract(events_persisted.payload,'$.data.STACKID')
	else json_extract(events_persisted.payload,'$.data.COMPID')
end as 'COMPID/STACKID',

-- baseData
case json_extract(events_persisted.payload,'$.data.baseData.action') 
	when 1 then 'Add'
	when 2 then 'Remove'
	else json_extract(events_persisted.payload,'$.data.baseData.action') 
end as 'action',
json_extract(events_persisted.payload,'$.data.baseData.inventoryId') as 'inventoryId',
json_extract(events_persisted.payload,'$.data.baseData.objectInstanceId') as 'InstanceId',
json_extract(events_persisted.payload,'$.data.baseData.objectType') as 'objectType',

	
-- Local, MS or AAD account 
trim(json_extract(events_persisted.payload,'$.ext.user.localId'),'m:') as 'UserId',
sid as 'User SID',

logging_binary_name

from events_persisted
where 
events_persisted.full_event_name like 'Microsoft.Windows.Inventory.Core.Inventory%' 

 -- Sort by event date dscending (newest first)
order by cast(events_persisted.timestamp as integer) desc