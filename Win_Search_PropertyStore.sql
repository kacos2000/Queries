-- This query is to show the content of the SystemIndex_1_PropertyStore table
-- of the new Windows.db (Win 11 search database)
--
-- Database location:
-- C:\ProgramData\Microsoft\Search\Data\Applications\Windows\Windows.db

SELECT
WorkId,
ColumnId,
-- Since the field is a BLOB, this will show either text of the hex value:
case 
when typeof(value) is 'text' or typeof(value) is 'integer'
then cast(value as 'text')
else hex(Value)
end as 'Value'

from SystemIndex_1_PropertyStore