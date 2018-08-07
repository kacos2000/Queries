-- https://developer.mozilla.org/en-US/docs/Mozilla/Tech/Places/Database
-- https://developer.mozilla.org/en-US/docs/Mozilla/Tech/Places/Frecency_algorithm
-- \AppData\Roaming\Mozilla\Firefox\Profiles\

select
moz_places.id as 'Id',
moz_bookmarks.id as 'bId',
moz_bookmarks.fk as 'fk',
moz_places.guid as 'P_guid',
moz_bookmarks.guid as 'B_guid', 
moz_bookmarks.title as 'Bookmark',
moz_places.url,
moz_places.title,
moz_places.description,
moz_places.preview_image_url,
moz_places.visit_count as 'count',
moz_annos.content,
datetime(moz_places.last_visit_date/1000000,'unixepoch','localtime') as 'Last',
datetime(moz_historyvisits.visit_date/1000000,'unixepoch','localtime' ) as ' LastVisit',
datetime(moz_annos.dateAdded/1000000,'unixepoch','localtime') as 'BookMarkAdded', 
datetime(moz_annos.lastModified/1000000,'unixepoch','localtime') as 'BookMarkModified',
moz_places.typed as 'P_Typed',
moz_hosts.typed as 'H_Typed',
moz_inputhistory.input,
moz_inputhistory.use_count,
moz_anno_attributes.name as 'type',
hex(moz_places.url_hash) as 'hash'

from moz_places
left join moz_bookmarks on moz_bookmarks.fk = moz_places.id
left join moz_annos on moz_annos.place_id = moz_places.id
left join moz_anno_attributes on moz_annos.anno_attribute_id = moz_anno_attributes.id
left join moz_historyvisits on moz_historyvisits.place_id = moz_places.id
left join moz_hosts on moz_hosts.id = moz_places.id
left join moz_inputhistory on moz_inputhistory.place_id = moz_places.id and moz_inputhistory.place_id = moz_bookmarks.fk
order by moz_places.id desc