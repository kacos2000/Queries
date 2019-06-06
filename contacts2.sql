select 
raw_contacts._id,
photo_id,
photo_file_id,

accounts.account_name,
case raw_contacts.deleted
	when 1 then 'Yes'
	end as 'deleted',
case raw_contacts.starred
	when 1 then 'Yes'
	end as'starred',
case raw_contacts.pinned
	when 1 then 'Yes'
	end as 'pinned',
case has_phone_number
	when 1 then 'Yes'
	end as 'hasnumber',
case raw_contacts.send_to_voicemail
	when 1 then 'Yes'
	end as 'sendtovoicemail',
raw_contacts.display_name,
search_index.content as 'content',
groups.title as 'group',
raw_contacts.times_contacted,
raw_contacts.last_time_contacted,
contact_last_updated_timestamp,
phonebook_bucket,
raw_contacts.sync1,
raw_contacts.sync2,
raw_contacts.sync3,
raw_contacts.sync4

from raw_contacts
join contacts on raw_contacts._id = contacts.name_raw_contact_id
join accounts on accounts._id = raw_contacts.account_id
join groups on groups._id = raw_contacts.account_id
left join search_index on search_index.contact_id=raw_contacts.contact_id