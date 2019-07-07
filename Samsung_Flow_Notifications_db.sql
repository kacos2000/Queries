-- Samsung Flow (Notifications.db)
-- https://www.samsung.com/us/support/owners/app/samsung-flow.html
-- dB Path: C:\Users\%UserName%\AppData\Local\Packages\SAMSUNGELECTRONICSCoLtd.SamsungFlux_wyx1vj98g3asy\LocalState
--
-- Note: Files in that location are EFS encrypted

Select 
	PackageName,
	"Group",
	"key",
	Count,
	NotiCategory as 'Category',
	AppDisplayName,
	Title,
	Content,
	case 
		when length(ticks) = 18
		then datetime((Ticks/10000000 -  62135596800), 'unixepoch') -- Filetime (10^-7)s intervals from 0h 1-Jan 1601
		when length(ticks) = 13
		then datetime(Ticks/1000.0, 'unixepoch', 'localtime')
		end as 'Timestamp', 
	case IsChat
		when 1 then 'Yes'
		end as 'IsChat',
	case IsDeleted
		when 1 then 'Yes'
		end as 'IsDeleted',	
	case IsRemovedFile
		when 1 then 'Yes'
		end as 'IsRemovedFile',
	case IsRemovedFromPhone
		when 1 then 'Yes'
		end as 'IsRemovedFromPhone',	
	case IsDeleted
		when 1 then 'Yes'
		end as 'IsDeleted',
	case IsFileDeleted
		when 1 then 'Yes'
		end as 'IsDeleted',
	FileSize,
	CompletedFileSize,
	RelativeFilePath,
	ReceivedFolderPath

from NotificationData
order by Timestamp desc