--IOS 9.3.1 (iphoto)
--\Camera Roll\Media\PhotoData\iPhotoSandboxLibrary\438665323315681\Database\iPhotoLite.db

select 
BLDBAlbum.uuid as 'AlbumUUID', -- Foldername
BLDBAlbumMediaJoin.type, -- value can also be seen in the Album.plist in the above folders
BLDBAlbum.name||' ('||BLDBAlbum.itemCount||')' as 'AlbumName(count)',
case BLDBAlbum.state 
	when 1 then 'Exists' end as 'AlbumState', 
case bldbmedia.state 
	when 0 then 'Deleted'
	end as 'MediaState',
bldbmedia.uuid 'Media UUID',
bldbmedia.fileName,
bldbmedia.fileSize,
bldbmedia.type as 'imageType',
time(bldbmedia.duration,'unixepoch') as 'Duration',
bldbmedia.latitude,
bldbmedia.longitude,
datetime('2001-01-01',bldbmedia.DateCreated || ' seconds') as 'DateCreated',
case when bldbmedia.dateViewed != 0.0 then datetime('2001-01-01',bldbmedia.dateViewed || ' seconds') end as 'DateViewed',
case when bldbmedia.dateAdjusted then datetime('2001-01-01',bldbmedia.dateAdjusted || ' seconds') end as 'DateAdjusted',
case when bldbmedia.dateModified then datetime('2001-01-01',bldbmedia.dateModified || ' seconds') end as 'DateModified',
bldbmedia.PixelWidth||' x '||bldbmedia.PixelHeight as 'Dimensions (WxH)',
bldbmedia.assetPixelWidth||' x '||bldbmedia.assetPixelHeight as 'assetDimensions',
bldbmedia.originalPixelWidth||' x '||bldbmedia.originalPixelHeight as 'originalDimensions',
case bldbmedia.assetOrientation    
		when 1 then 'Horizontal (left)'
		when 3 then 'Horizontal (right)'
		when 6 then 'Vertical (up)'
		when 8 then 'Vertical (down)'
		else bldbmedia.assetOrientation
		end as 'AssetOrientation',
case bldbmedia.originalOrientation    
		when 1 then 'Horizontal (left)'
		when 3 then 'Horizontal (right)'
		when 6 then 'Vertical (up)'
		when 8 then 'Vertical (down)'
		else bldbmedia.originalOrientation
		end as 'OriginalOrientation'


from bldbmedia
join BLDBAlbumMediaJoin on BLDBMedia.primaryKey = BLDBAlbumMediaJoin.mediaKey
join BLDBAlbum on BLDBAlbumMediaJoin.albumKey = BLDBAlbum.primaryKey

order by DateCreated desc