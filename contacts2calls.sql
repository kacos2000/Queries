-- Android 9 -  Contacts2.db Call History

Select 
id,
name,
number,
case type
	when 1 then 'incoming' --incoming calls
	when 2 then 'outgoing' --outgoing calls
	when 3 then 'missed' --missed calls
	when 4 then 'voicemail' --Call log type for voicemails
	when 5 then 'rejected' --rejected by direct user action
	when 6 then 'blocked' --calls blocked automatically
	when 7 then 'answered externally' --call which was answered on another device
	else type
end as 'type',
datetime(date/1000,'unixepoch','localtime') as 'date',
time(duration,'unixepoch') as 'duration'
from calls
order by id desc
