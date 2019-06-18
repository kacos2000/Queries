-- IOS \Home\Library\Mail

select 
recents.ROWID,
contacts.kind,
recents.sending_address,
contacts.address,
contacts.display_name,
metadata.key,
metadata.value, --BLOB: bplist
recents.original_source as 'source',
recents.dates, --dates in Unix milliseconds
datetime(recents.last_date/1000, 'unixepoch') as 'lastdate',
recents.weight,
recents.record_hash,
recents."count",
recents.group_kind 

from recents
 join contacts on recents.ROWID = contacts.recent_id 
 left join metadata on metadata.recent_id = recents.ROWID

-- group by recents.ROWID (to omit multiple entries)
order by lastdate desc