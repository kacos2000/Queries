-- sec = (Samsung Electronics Corporation)
-- \data\com.sec.android.provider.logsproviders\logs.db

Select 
	logs._id as 'id',
	logs.geocoded_location||' ('||logs.countryiso||')' as 'Location',
	logs.name,
	logs.number,
	case logs.numbertype 
		when 1 then 'Home'
		when 2 then 'Mobile'
		when 3 then 'Work'
		when 4 then 'Fax_Work'
		when 5 then 'Fax_Home'
		when 6 then 'Pager'
		when 7 then 'Other'
		when 8 then 'Callback'
		when 9 then 'Car'
		when 10 then 'Company_Main'
		when 11 then 'ISDN'
		when 12 then 'Main'
		when 13 then 'Other_Fax'
		when 14 then 'Radio'
		when 15 then 'Telex'
		when 16 then 'TTY_TDD'
		when 17 then 'Work_Mobile'
		when 18 then 'Work_Pager'
		when 19 then 'Assistant'
		when 20 then 'MMS'
		else logs.numbertype
		end as 'numbertype',
	case logs.presentation
		when 1 then 'allowed' --Number is allowed to display for caller id
		when 2 then 'restricted' --Number is blocked by user
		when 3 then 'unknown'  --Number is not specified or unknown by network
		when 4 then 'pay phone' --Number is a pay phone
		else logs.presentation
		end as 'CallerID',	
	datetime(logs.date/1000, 'unixepoch') as 'lDate',
	case 
		when logs.duration != 0
		then Time(logs.duration, 'unixepoch') 
		end as 'Duration',--The duration of the call in seconds
	case logs.type
		when 1 then 'incoming' --incoming calls
		when 2 then 'outgoing' --outgoing calls
		when 3 then 'missed' --missed calls
		when 4 then 'voicemail' --Call log type for voicemails
		when 5 then 'rejected' --rejected by direct user action
		when 6 then 'blocked' --calls blocked automatically
		when 7 then 'answered externally' --call which was answered on another device
		else logs.type
	end as 'type',	
	case 
		when logs.logtype in (100)
		then 'Call ('||logs.logtype||')'
		when logs.logtype in (300)
		then 'SMS ('||logs.logtype||')'
		when logs.logtype in (400)
		then 'Email ('||logs.logtype||')'
		else 'Other ('||logs.logtype||')'
		end as 'logtype',
	logs.messageid,		
	case logs.is_read
		when 0 then 'No'
		when 1 then 'Yes'
		end as 'IsRead',
	logs.m_subject as 'MessageSubject',
	logs.m_content as 'MessageContent',
	case logs."new"
		when 1 then 'Yes'
		end as 'New',
	logs.contactid,
	logs.raw_contact_id,
	logs.lookup_uri,
	logs.photo_id,
	logs.account_name||' ('||logs.account_id||')' as 'Account'
from logs
order by lDate desc