-- Microsoft.Windows.FileSystem
--      NTFS,EXFAT,FAT Mount + Volume Info
--      ProcessLoggingRegistry
-- from C:\ProgramData\Microsoft\Diagnosis\EventTranscript\EventTranscript.db

SELECT

--Timestamp from db field
json_extract(events_persisted.payload,'$.time') as 'UTC TimeStamp',

-- Timestamp from json payload
datetime((timestamp - 116444736000000000)/10000000, 'unixepoch','localtime') as 'Local TimeStamp',
json_extract(events_persisted.payload,'$.ext.loc.tz') as 'TimeZome',
json_extract(events_persisted.payload,'$.ext.utc.seq') as 'seq', 

-- Event
replace(events_persisted.full_event_name,'Microsoft.Windows.FileSystem.','') as 'Event',

-- Mount info
json_extract(events_persisted.payload,'$.data.mountStartTime') as 'mountStartTime', 
json_extract(events_persisted.payload,'$.data.mountGuid') as 'mountGuid',
json_extract(events_persisted.payload,'$.data.vendorId') as 'vendor',
json_extract(events_persisted.payload,'$.data.productId') as 'productId',
json_extract(events_persisted.payload,'$.data.diskId') as 'diskId',
case json_extract(events_persisted.payload,'$.data.volumeFat32') 
	when true then 'Yes'
	end as 'volumeFat32',
json_extract(events_persisted.payload,'$.data.volumeId') as 'volumeId',
json_extract(events_persisted.payload,'$.data.volumeCreationTime') as 'volumeCreationTime', 

-- only available on FAT/EXFAT Volumes	
case json_extract(events_persisted.payload,'$.data.volumeMountedDirty') 
	when true then 'Yes'
	when false then 'No'
	end as 'Dirty',
case json_extract(events_persisted.payload,'$.data.volumeMountedReadOnly') 
	when true then 'Yes'
	when false then 'No'
	end as 'ReadOnly',

json_extract(events_persisted.payload,'$.data.volumeFat32') as 'volumeFat32',
json_extract(events_persisted.payload,'$.data.totalClusters') as 'totalClusters',
json_extract(events_persisted.payload,'$.data.clusterSizeBytes') as 'clusterSize',
-- from VolumeInfo
json_extract(events_persisted.payload,'$.data.physicalSectorSizeBytes') as 'physicalSectorSizeBytes',
json_extract(events_persisted.payload,'$.data.logicalSectorSizeBytes') as 'logicalSectorSizeBytes'
-- json_extract(events_persisted.payload,'$.data.originalVolumeId') as 'originalVolumeId'

from events_persisted
where 
events_persisted.full_event_name like 'Microsoft.Windows.FileSystem.%' and
(events_persisted.full_event_name like '%Mount%' or 
events_persisted.full_event_name like '%VolumeInfo' )

 -- Sort by event date dscending (newest first)
order by cast(events_persisted.timestamp as integer) desc
