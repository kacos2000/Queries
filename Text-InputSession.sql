-- Diagnostic 
--           Microsoft.Windows.Desktop.TextInput.TextServiceFramework
-- from C:\ProgramData\Microsoft\Diagnosis\EventTranscript\EventTranscript.db

SELECT

--Timestamp from db field
json_extract(events_persisted.payload,'$.time') as 'UTC TimeStamp',

-- Timestamp from json payload
datetime((timestamp - 116444736000000000)/10000000, 'unixepoch','localtime') as 'Local TimeStamp',
json_extract(events_persisted.payload,'$.ext.loc.tz') as 'TimeZome',
json_extract(events_persisted.payload,'$.ext.utc.seq') as 'seq', 

-- Event
replace(events_persisted.full_event_name,'Microsoft.Windows.Desktop.TextInput.TextServiceFramework.InputSession','') as 'InputSession',
json_extract(events_persisted.payload,'$.data.applicationName') as 'applicationName',
json_extract(events_persisted.payload,'$.data.processId') as 'processId',
json_extract(events_persisted.payload,'$.data.staticFlags') as 'staticFlags',

-- InputScopeNameValue: Specifies a particular named input mode
-- Values list:
-- https://docs.microsoft.com/en-us/uwp/api/windows.ui.xaml.input.inputscopenamevalue?view=winrt-20348
case json_extract(events_persisted.payload,'$.data.inputScope') 
	when 0 then 'Default' -- No input scope is applied 
	when 1 then 'Url'
	when 31 then 'Password'
	when 50 then 'Search'
	when 32 then 'TelephoneNumber'
	when 57 then 'Text'
	when 5 then 'EmailSmtpAddress' -- (?) Input scope is intended for working with a (SMTP) form e-mail address (accountname@host)
	else json_extract(events_persisted.payload,'$.data.inputScope')												
end as 'inputScope',
-- https://docs.microsoft.com/en-us/windows/win32/intl/language-identifiers
-- https://docs.microsoft.com/en-us/windows/win32/msi/localizing-the-error-and-actiontext-tables
json_extract(events_persisted.payload,'$.data.langId') as 'langId',
json_extract(events_persisted.payload,'$.data.insertedCharacterCount') as 'InsCharCount', -- nr of inserted characters
json_extract(events_persisted.payload,'$.data.keyCount') as 'keyCount', -- Pressed key count 
json_extract(events_persisted.payload,'$.data.imeBackspaceCount') as 'BackspaceCount', --  backspace key press count
strftime('%H:%M:%f',json_extract(events_persisted.payload,'$.data.totalTimeMilliseconds')/1000.0, 'unixepoch') as 'totalTime',

-- Possible Conversion Mode Values
-- https://docs.microsoft.com/en-us/windows/win32/intl/ime-conversion-mode-values
json_extract(events_persisted.payload,'$.data.conversionMode') as 'conversionMode',

-- App Info
case substr(json_extract(events_persisted.payload,'$.ext.app.id'),1,1) 
	when 'U' then "UWP"
	when 'W' then "Win"
	else substr(json_extract(events_persisted.payload,'$.ext.app.id'),1,1) 
	end as 'App Type',
	
-- Application Name
case when substr(json_extract(events_persisted.payload,'$.ext.app.id'),1,1) is 'W' -- Windows Application x32/x64
	then substr(json_extract(events_persisted.payload,'$.ext.app.id'),93) 
	else substr(json_extract(events_persisted.payload,'$.ext.app.id'),3)
	end as 'App Name',	

-- SHA1 Hash of the application that produced this event	
case when substr(json_extract(events_persisted.payload,'$.ext.app.id'),1,1) is 'W' -- Windows Application x32/x64
	then upper(substr(json_extract(events_persisted.payload,'$.ext.app.id'),52,40 ))
	-- Same as the 'FileId' in Amcache.hve (Root\InventoryApplicationFile\)
	end as 'AppId SHA1',	-- (SHA1 Base16) checked & verified 

-- ProgramId of the application that produced this event	
case when substr(json_extract(events_persisted.payload,'$.ext.app.id'),1,1) is 'W' -- Windows Application x32/x64
	then upper(substr(json_extract(events_persisted.payload,'$.ext.app.id'),3,44 )) 
	end as 'ProgramId',   -- Same as the 'ProgramId' in Amcache.hve (Root\InventoryApplicationFile\)		
	
-- Version of the application that produced this event	
case when substr(json_extract(events_persisted.payload,'$.ext.app.id'),1,1) is 'W' -- Windows Application x32/x64
	then substr(json_extract(events_persisted.payload,'$.ext.app.ver'),1,19 ) 
	end as 'AppVersion Date',   -- Same as the 'LinkDate' in Amcache.hve (Root\InventoryApplicationFile\)	 

case when substr(json_extract(events_persisted.payload,'$.ext.app.id'),1,1) is 'W' -- Windows Application x32/x64
	then substr(json_extract(events_persisted.payload,'$.ext.app.ver'),21,(instr(substr(json_extract(events_persisted.payload,'$.ext.app.ver'),21),'!')-1) )
	end as 'PE Header CheckSum',	-- PE Header CheckSum variable size (4-6)
	
case when substr(json_extract(events_persisted.payload,'$.ext.app.id'),1,1) is 'W' -- Windows Application x32/x64
	then substr(json_extract(events_persisted.payload,'$.ext.app.ver'),(instr(substr(json_extract(events_persisted.payload,'$.ext.app.ver'),22),'!')+22)) 
	else json_extract(events_persisted.payload,'$.ext.app.ver')
	end as 'Executable',	

	
-- Local, MS or AAD account 
trim(json_extract(events_persisted.payload,'$.ext.user.localId'),'m:') as 'UserId',
sid as 'User SID',

logging_binary_name

from events_persisted
where events_persisted.full_event_name like 'Microsoft.Windows.Desktop.TextInput.TextServiceFramework.%'

 -- Sort by event date dscending (newest first)
order by cast(events_persisted.timestamp as integer) desc