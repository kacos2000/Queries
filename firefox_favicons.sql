-- \AppData\Roaming\Mozilla\Firefox\Profiles\

select 
moz_icons.id as 'IconId',
moz_pages_w_icons.id as 'PageID',
moz_icons_to_pages.icon_id as 'iId',
moz_icons_to_pages.page_id as 'pID',
moz_pages_w_icons.page_url as 'Url',
moz_icons.icon_url as 'IconUrl',
moz_icons.width as 'Width',
moz_icons.root as 'Root',
moz_icons.color as 'Color',
case when moz_icons.expire_ms <> 0 then datetime(moz_icons.expire_ms/1000,'unixepoch','localtime') else '' end as 'Expire',
hex(moz_icons.fixed_icon_url_hash) as 'IconHash',
hex(moz_pages_w_icons.page_url_hash) as 'UrlHash'

from moz_icons_to_pages
left join moz_icons on moz_icons.id = moz_icons_to_pages.icon_id
left join moz_pages_w_icons on moz_pages_w_icons.id = moz_icons_to_pages.page_id
order by Expire desc