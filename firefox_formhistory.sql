-- \AppData\Roaming\Mozilla\Firefox\Profiles\

select 
moz_formhistory.id as 'Id',
moz_formhistory.fieldname as 'FieldName',
moz_formhistory.value as 'Value',
moz_formhistory.timesUsed as 'TimesUsed',
datetime(moz_formhistory.firstUsed/1000000,'unixepoch','localtime') as 'FirstUsed',
datetime(moz_formhistory.lastUsed/1000000,'unixepoch','localtime') as 'LastUsed',
moz_formhistory.guid as 'Guid'
from moz_formhistory
order by LastUsed desc