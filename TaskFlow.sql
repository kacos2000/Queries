-- Diagnostic  'Microsoft.Windows.Shell.TaskFlow.DataEngine'
-- from C:\ProgramData\Microsoft\Diagnosis\EventTranscript\EventTranscript.db

SELECT

--Timestamp from db field
json_extract(events_persisted.payload,'$.time') as 'UTC TimeStamp',

-- Timestamp from json payload
datetime((timestamp - 116444736000000000)/10000000, 'unixepoch','localtime') as 'Local TimeStamp',
json_extract(events_persisted.payload,'$.ext.loc.tz') as 'TimeZome',
json_extract(events_persisted.payload,'$.ext.utc.seq') as 'seq', 

-- Event
replace(replace(replace(events_persisted.full_event_name,'Microsoft.Windows.Shell.TaskFlow.DataEngine.',''),'Aggregate.',''),'Handle','') as 'InputSession',
json_extract(events_persisted.payload,'$.data.Count') as 'Count',
case json_extract(events_persisted.payload,'$.data.IsRetryable') 
	when 1 then 'Yes'
	when 0 then 'No'
	end as 'IsRetryable',
-- json_extract(events_persisted.payload,'$.data.hr') as 'hr',
-- json_extract(events_persisted.payload,'$.data.wilActivity.hresult') as 'hresult',

-- info
case json_extract(events_persisted.payload,'$.data.signalType') 
	when 0 then 'Copy ('||json_extract(events_persisted.payload,'$.data.signalType')||')'
	when 1 then 'Paste ('||json_extract(events_persisted.payload,'$.data.signalType')||')'
	end as 'signalType',
json_extract(events_persisted.payload,'$.data.wilActivity.threadId') as 'threadId',
replace(replace(coalesce(json_extract(events_persisted.payload,'$.data.ActivityId'),json_extract(events_persisted.payload,'$.data.clipboardDataId'),json_extract(events_persisted.payload,'$.data.activityId')),'{',''),'}','') as 'ActivityId/clipboardDataId',
json_extract(events_persisted.payload,'$.data.appId') as 'AppId',
case json_extract(events_persisted.payload,'$.data.hasContentUri') 
	when true then 'Yes'
	when false then 'No'
	end as 'hasContentUri',

-- Other counters	
coalesce(json_extract(events_persisted.payload,'$.data.activityItemCount'),json_extract(events_persisted.payload,'$.data.historyItemCount')) as 'Activity/History ItemCount',	
case json_extract(events_persisted.payload,'$.data.bulkHistoryDeleteReason') 
	when 2 then 'Expired'
	else json_extract(events_persisted.payload,'$.data.bulkHistoryDeleteReason')
	end as 'bulkHistoryDeleteReason',	
	json_extract(events_persisted.payload,'$.data.RecentBulkHistoryDeleteResult') as 'RecentBulkHistoryDeleteResult',
	json_extract(events_persisted.payload,'$.data.RecentBulkHistoryDeleteTime') as 'RecentBulkHistoryDeleteTime',
	
-- Clipboard stats/counters
json_extract(events_persisted.payload,'$.data.successCounter') as 'successCounter',
json_extract(events_persisted.payload,'$.data.filteredOutHistoriesCounter') as 'filteredOutHistoriesCounter',
json_extract(events_persisted.payload,'$.data.historiesCounter') as 'historiesCounter',
json_extract(events_persisted.payload,'$.data.historyFilteringThreshold') as 'historyFilteringThreshold',
json_extract(events_persisted.payload,'$.data.historyMergedGapLimitInSeconds') as 'historyMergedGapLimitInSeconds',
json_extract(events_persisted.payload,'$.data.knownFailureCounter') as 'knownFailureCounter',	
json_extract(events_persisted.payload,'$.data.unknownFailureCounter') as 'unknownFailureCounter',
	
-- Policy	
case json_extract(events_persisted.payload,'$.data.ActivityHistoryUploadToCloud') 
	when 1 then 'Yes'
	when 0 then 'No'
	end as 'ActivityHistoryUploadToCloud', 
case json_extract(events_persisted.payload,'$.data.ActivityTrackingAllowed') 
	when 1 then 'Yes'
	when 0 then 'No'
	end as 'ActivityTrackingAllowed',	

-- Local, MS or AAD account 
json_extract(events_persisted.payload,'$.data.accountId') as 'accountId',
trim(json_extract(events_persisted.payload,'$.ext.user.localId'),'m:') as 'UserId',
sid as 'User SID',

logging_binary_name

from events_persisted
where 
events_persisted.full_event_name like 'Microsoft.Windows.Shell.TaskFlow.DataEngine.%' and
(events_persisted.full_event_name not like '%GroupQueryActivity%' and
events_persisted.full_event_name not like '%CDPInitializeResult%' and
events_persisted.full_event_name not like '%SubscribedToAFC%' and
events_persisted.full_event_name not like '%GetActivityActivationStateAsync%' and
events_persisted.full_event_name not like '%lListener%' and
events_persisted.full_event_name not like '%SubscribedToAFC%' and
events_persisted.full_event_name not like '%ActivityIndexerStateIndexUpdate%' and
events_persisted.full_event_name not like '%ActivityIndexerStateAFC%' and
events_persisted.full_event_name not like '%TaskflowImmersiveShellBroker_StartupPerf%' and
events_persisted.full_event_name not like '%ActivityIndexerStatePerAccount%')

 -- Sort by event date dscending (newest first)
order by cast(events_persisted.timestamp as integer) desc