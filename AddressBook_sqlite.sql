-- IOS 
-- Database: Home\Library\AddressBook\AddressBook.sqlitedb

Select 
ABAccount.AccountIdentifier,
abstore.Name as 'Store',
abperson.ExternalIdentifier,
ABPerson.ImageURI,
abperson.Last,
abperson.First,
abperson.Middle,
abperson.Organization,
abperson.Department,
ABPerson.JobTitle,
ABPerson.Nickname,
abperson.Note,
date('2001-01-01', abperson.Birthday || ' seconds') as 'Birthdate',

(select 
	value from ABMultiValue where property = 3 and record_id = ABPerson.ROWID and 
	label = (select ROWID from ABMultiValueLabel where value = '_$!<Main>!$_')) as 'Main',
(select 
	value from ABMultiValue where property = 3 and record_id = ABPerson.ROWID and 
	label = (select ROWID from ABMultiValueLabel where value = 'iPhone')) as 'iPhone',	
(select 
	value from ABMultiValue where property = 3 and record_id = ABPerson.ROWID and 
	label = (select ROWID from ABMultiValueLabel where value = '_$!<Other>!$_')) as 'Other',	

-- Following part from https://gist.github.com/laacz/1180765
(select 
	value from ABMultiValue where property = 3 and record_id = ABPerson.ROWID and 
	label = (select ROWID from ABMultiValueLabel where value = '_$!<Mobile>!$_')) as 'Mobile',
(select 
	value from ABMultiValue where property = 3 and record_id = ABPerson.ROWID and 
	label = (select ROWID from ABMultiValueLabel where value = '_$!<Home>!$_')) as 'Home',
(select 
	value from ABMultiValue where property = 3 and record_id = ABPerson.ROWID and 
	label = (select ROWID from ABMultiValueLabel where value = '_$!<Work>!$_')) as 'Work',
(select 
	value from ABMultiValue where property = 4 and record_id = ABPerson.ROWID and 
	label is null) as 'email',
(select 
	value from ABMultiValueEntry where parent_id in (select ROWID from ABMultiValue 
	where record_id = ABPerson.ROWID) and key = (select ROWID from ABMultiValueEntryKey 
	where lower(value) = 'street')) as 'address',
(select 
	value from ABMultiValueEntry where parent_id in (select ROWID from ABMultiValue 
	where record_id = ABPerson.ROWID) and key = (select ROWID from ABMultiValueEntryKey 
	where lower(value) = 'city')) as 'city',
-- End code from https://gist.github.com/laacz/1180765

datetime('2001-01-01', abperson.CreationDate || ' seconds') as 'CreationDate',
datetime('2001-01-01', abperson.ModificationDate|| ' seconds') as 'ModificationDate',
abperson.MapsData,
ABPerson.ExternalRepresentation as 'External (blob)',
ABStore.ExternalSyncTag

from abperson
	join ABStore on abperson.StoreID = ABStore.ROWID
	join ABAccount on ABStore.AccountID = ABAccount.ROWID
