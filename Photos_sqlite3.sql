-- IOS (iPhone3GS_4.3-4.3.1) /Data/mobile/Media/PhotoData/Photos.sqlite
-- source db:
-- https://www.cfreds.nist.gov/mobile/cellebrite/iPhone%203GS/iPhone3GS%20Physical/Reports/html/report.html#data-files-database 

Select 
PhotoAlbum.title as 'AlbumTitle',
PhotoAlbum.objC_class as 'Class', 
Photo.directory,
Photo.filename,
Photo.width||' x '||Photo.height as 'Dimensions',
case Photo.orientation    
		when 1 then 'Horizontal (left)'
		when 3 then 'Horizontal (right)'
		when 6 then 'Vertical (up)'
		when 8 then 'Vertical (down)'
		else Photo.orientation
		end as 'Orientation',
datetime('2001-01-01', photo.captureTime || ' seconds') as 'CaptureTime',
datetime('2001-01-01', Photo.recordModDate || ' seconds') as 'recordModDate',		
Photo.type,
Photo.title as 'PhotoTitle',
Photo.thumbnailIndex,
Photo.savedAssetType,
--PhotoExtras values:
(select value from PhotoExtras where identifier = 1 and foreignKey = photo.primaryKey) as 'Album',
(select value from PhotoExtras where identifier = 2 and foreignKey = photo.primaryKey) as 'Filename',
(select value from PhotoExtras where identifier = 3 and foreignKey = photo.primaryKey) as 'Size',
(select value from PhotoExtras where identifier = 6 and foreignKey = photo.primaryKey) as 'Data(blob)',
(select value from PhotoExtras where identifier = 7 and foreignKey = photo.primaryKey) as 'pe7',
(select value from PhotoExtras where identifier = 8 and foreignKey = photo.primaryKey) as 'blob',
(select value from PhotoExtras where identifier = 9 and foreignKey = photo.primaryKey) as 'px9',
(select value from PhotoExtras where identifier = 10 and foreignKey = photo.primaryKey) as 'Orientation',
(select value from PhotoExtras where identifier = 13 and foreignKey = photo.primaryKey) as 'px13'

from Photo
join PhotoAlbumToPhotoJoin on Photo.primaryKey = PhotoAlbumToPhotoJoin.primaryKey
left join PhotoAlbum on PhotoAlbum.primaryKey = PhotoAlbumToPhotoJoin.left
