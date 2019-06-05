-- references: 
-- https://developer.android.com/reference/android/provider/CallLog.Calls.html
-- https://developer.android.com/reference/android/provider/ContactsContract.CommonDataKinds.Phone
--
--
-- Costas Katsavounidis © 06/2019 

SELECT
calls._id,
number, --The phone number as the user entered it.
case presentation
	when 1 then 'allowed' --Number is allowed to display for caller id
	when 2 then 'restricted' --Number is blocked by user
	when 3 then 'unknown'  --Number is not specified or unknown by network
	when 4 then 'pay phone' --Number is a pay phone
	else presentation
	end as 'CallerIDtype',
case calls.new -- Whether or not the call has been acknowledged
	when 1 then 'yes'
	else ''
	end as 'New',
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
-- ISREAD >> Unlike the NEW field, which requires the user to have acknowledged the existence of the entry, 
-- this implies the user has interacted with the entry. 
case is_read -- Whether this item has been read or otherwise consumed by the user. 
	when 1 then 'yes'
	else ''
	end as 'is read',
operator||' ('||countryiso||')' as 'Operator',
geocoded_location, --The string represents a city, state, or country associated with the number associated with this call 
matched_number,
case numbertype --cached number type (Home, Work, etc) associated with the phone number
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
	else numbertype
	end as 'numbertype',
formatted_number,
post_dial_digits, --post-dial portion of a dialed number
name,
duration, --The duration of the call in seconds 
datetime(date/1000, 'unixepoch','localtime') as 'call_date', --The date the call occured, in milliseconds since the epoch 
datetime(last_modified/1000, 'unixepoch','localtime') as 'lastmodified',--The date the row is last inserted, updated, or marked as deleted, in milliseconds since the epoch
photo_id,
photo_uri,
via_number, -- the via number indicates which of the numbers associated with the SIM was called
phone_account_address, --The identifier for the account used to place or receive the call
subscription_id as 'sid', --The identifier for the account used to place or receive the call,

calls._data,
transcription, --only be populated for call log entries of type VOICEMAIL_TYPE that have valid transcriptions
mime_type,
case dirty
	when 1 then 'yes'
	end as 'dirty',
case deleted 
	when 0 then 'no' 
	when 1 then 'yes' 
	end as 'deleted'
from calls
order by calls._id desc

