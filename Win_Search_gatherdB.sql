-- This query is to show the content of the SystemIndex_1_PropertyStore table
-- of the new Win 11 search databases (Windows-gather.db)
--
-- Database location:
-- C:\ProgramData\Microsoft\Search\Data\Applications\Windows\Windows-gather.db

Select 

SystemIndex_GthrPth.Parent,
SystemIndex_GthrPth.Name as 'Parent Name',
FileName,
DocumentID,
AppOwnerId,
-- Hex String
hex(LastModified) as 'LastModified',
-- Convert LastModified to Little Endian Hex
substr(hex(LastModified), -2, 1) || substr(hex(LastModified), -1, 1) ||
substr(hex(LastModified), -4, 1) || substr(hex(LastModified), -3, 1) ||
substr(hex(LastModified), -6, 1) || substr(hex(LastModified), -5, 1) ||
substr(hex(LastModified), -8, 1) || substr(hex(LastModified), -7, 1) ||
substr(hex(LastModified), -10, 1) || substr(hex(LastModified), -9, 1) ||
substr(hex(LastModified), -12, 1) || substr(hex(LastModified), -11, 1) ||
substr(hex(LastModified), -14, 1) || substr(hex(LastModified), -13, 1) ||
substr(hex(LastModified), -16, 1) || substr(hex(LastModified), -15, 1) as 'LastModifiedHexLE',

DeletedCount,
TransactionFlags,
TransactionExtendedFlags,
RunTime,
ClientID,
LastRequestedRunTime,
StorageProviderId

from SystemIndex_Gthr
join SystemIndex_GthrPth on SystemIndex_Gthr.ScopeID = SystemIndex_GthrPth.Scope