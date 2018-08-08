select
favicons.icon_type as 'Icon_type',
icon_mapping.id as 'id',
favicons.id as 'fid',
favicon_bitmaps.id as 'bid',
favicons.url as 'Favicon_url',
icon_mapping.page_url as 'Page_url',
case when favicon_bitmaps.last_updated <> 0 then datetime((favicon_bitmaps.last_updated/1000000)-11644473600,'unixepoch','localtime') else '' end as 'LastUpdated',
case when favicon_bitmaps.last_requested <> 0 then datetime((favicon_bitmaps.last_requested/1000000)-11644473600,'unixepoch','localtime') else '' end as 'Lastrequested',
favicon_bitmaps.height,
favicon_bitmaps.icon_id,
favicon_bitmaps.id,
favicon_bitmaps.width,
hex(favicon_bitmaps.image_data) as 'Image_data(PNG)'

from icon_mapping
join favicons on favicons.id = icon_mapping.icon_id
left join favicon_bitmaps on favicon_bitmaps.id = favicons.id
order by id desc