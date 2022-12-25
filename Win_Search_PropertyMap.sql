-- This query is to show the content of the PropertyMap table
-- of the new Windows.db (Win 11 search database)
--
-- Database location:
-- C:\ProgramData\Microsoft\Search\Data\Applications\Windows\Projects\SystemIndex\PropMap\PropMap.db

SELECT
Id,
StandardId,
FormatIdQualifier,
Size,

-- Since the field is a BLOB, this will show either text of the hex value:
case 
when typeof(FormatId) is 'text' or typeof(FormatId) is 'integer'
then cast(FormatId as 'text')
else hex(FormatId)
end as 'FormatId'

from PropertyMap