select 
prefs.id as 'ID',
prefs.groupID as 'gID',
prefs.settingID as 'sID',
groups.name as 'SourceURL',
prefs.value as 'TargetFolder',
datetime(prefs.timestamp,'unixepoch','localtime') as 'TimeStamp',
settings.name as 'Setting'

from prefs
join groups on prefs.groupID = groups.id
join settings on prefs.settingID = settings.id
order by TimeStamp desc