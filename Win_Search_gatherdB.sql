-- This query is to show the content of the Gather tables
-- of the new Win 11 search databases (Windows-gather.db)
-- Table SystemIndex_GthrPth holds the main paths & Scope/Parent IDs linked to
-- the table SystemIndex_Gthr ScopeIDs.
-- The SystemIndex_Gthr table's DocumentIDs link the entries to the Information on
-- the entry stored in the 'SystemIndex_1_PropertyStore' table on
-- the separate SQLite dB 'Windows.db' in the same file location.
--
-- Database location:
-- C:\ProgramData\Microsoft\Search\Data\Applications\Windows\Windows-gather.db

Select 
SystemIndex_GthrPth.Scope as 'Scope',
SystemIndex_GthrPth.Parent as 'Parent',
SystemIndex_GthrPth.Name as 'Parent Name',
FileName,
DocumentID,
AppOwnerId,
-- Get the LastModified Blob as a Hex String (Filetime LE) 
hex(LastModified) as 'LastModifiedHex',

DeletedCount,
TransactionFlags,
TransactionExtendedFlags,
RunTime,
ClientID,
LastRequestedRunTime,
StorageProviderId

from SystemIndex_Gthr
left join SystemIndex_GthrPth on SystemIndex_Gthr.ScopeID = SystemIndex_GthrPth.Scope
order by cast(SystemIndex_GthrPth.Scope as INTEGER) ASC, cast(SystemIndex_GthrPth.Parent as INTEGER) ASC
