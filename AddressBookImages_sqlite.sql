-- References:
-- https://docs.microsoft.com/en-us/dotnet/api/addressbook.abpersonimageformat?view=xamarin-ios-sdk-12

Select 

ABFullSizeImage.record_id as 'RecordID', -- Should correspond to respective ROWID of the ABperson table in Addressbook.sqlite
ABFullSizeImage.crop_x||' x '||ABFullSizeImage.crop_y as 'Crop(xy)',
ABFullSizeImage.crop_width as 'CropWidth',
ABFullSizeImage.data as 'Image(blob)',
ABThumbnailImage.data as 'Thumbnail(blob)',
ABThumbnailImage.format as 'ImageFormat',
case ABThumbnailImage.derived_from_format 
	when 0 then 'Thumbnail'
	when 2 then 'OriginalSize'
	else ABThumbnailImage.derived_from_format
	end as 'DerivedFrom'

from ABfullsizeimage
	join ABThumbnailImage on ABThumbnailImage.record_id = ABFullSizeImage.record_id

