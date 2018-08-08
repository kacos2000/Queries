-- \AppData\Roaming\Mozilla\Firefox\Profiles\

select 

favicons.url,
favicons.icon_type,
favicons.id,

favicon_bitmaps.height,
favicon_bitmaps.icon_id,
favicon_bitmaps.id,
favicon_bitmaps.width,
datetime((favicon_bitmaps.last_updated/1000000)-11644473600,'unixepoch','localtime') as 'LastUpdated',
case when favicon_bitmaps.last_requested <> 0 then datetime((favicon_bitmaps.last_requested/1000000)-11644473600,'unixepoch','localtime') else '' end as 'Lastrequested',
hex(favicon_bitmaps.image_data) as 'Image_data'


from icon_mapping
left join favicon_bitmaps on favicon_bitmaps.icon_id = icon_mapping.icon_id
left join favicons on favicons.id = icon_mapping.icon_id
