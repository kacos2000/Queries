-- This query is to show the content of the SecurityDescriptor table
-- of the new SecStore.db (Win 11 search database)
--
-- Database location:
-- C:\ProgramData\Microsoft\Search\Data\Applications\Windows\Projects\SystemIndex\SecStore\SecStore.db

Select 
Id,
-- Since the field 'Value' is a BLOB containing Text
-- but has many separator which might cause mis-handling from, DB Browser & CSV tools,
-- this will show the content in quotes:
quote(value) as 'Value',
-- Remove null value from columns
case when EnterpriseIds notnull
then EnterpriseIds else ""
end as 'EnterpriseIds'

from SecurityDescriptor