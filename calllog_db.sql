-- reference: https://developer.android.com/reference/android/provider/CallLog.Calls.html
-- Costas Katsavounidis © 2019 

SELECT
calls._id,
subscription_id,
case calls.new -- Whether or not the call has been acknowledged
	when 1 then 'yes'
	else ''
	end as 'New',
case type
	when 1 then 'answered'
	when 2 then 'outgoing'
	when 3 then 'missed'
	when 4 then 'voicemail'
	when 5 then 'rejected'
	when 6 then 'blocked'
	when 7 then 'answered externally'
	else type
	end as 'type',
-- ISREAD >> Unlike the NEW field, which requires the user to have acknowledged the existence of the entry, 
-- this implies the user has interacted with the entry. 
case is_read -- Whether this item has been read or otherwise consumed by the user. 
	when 1 then 'yes'
	else ''
	end as 'is read',
countryiso,
operator,
number,
matched_number,
numbertype,
formatted_number,
post_dial_digits,
name,
geocoded_location,
duration,
datetime(date/1000, 'unixepoch','localtime') as 'call_date',
datetime(last_modified/1000, 'unixepoch','localtime') as 'lastmodified',
photo_id,
photo_uri,
calls._data,
transcription,
case dirty
	when 1 then 'yes'
	end as 'dirty',
case deleted 
	when 0 then 'no' 
	when 1 then 'yes' 
	end as 'deleted'
from calls
order by calls._id desc

