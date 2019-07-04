-- IOS 11/12 - Camera Roll\Media\PhotoData\Photos.sqlite

-- References:
--
-- https://github.com/geiszla/iOSLib/wiki/ZGENERICASSET-contents
-- https://github.com/geiszla/iOSLib/wiki/ZADDITIONALASSETATTRIBUTES-contents
-- https://forensenellanebbia.blogspot.com/2015/10/apple-ios-recently-deleted-images.html
-- SIDECAR https://en.wikipedia.org/wiki/Sidecar_file
--
-- Live Photo is a video-picture hybrid file with both animated MOV and static JPG combined. 
-- https://appletoolbox.com/live-photos-on-iphone-complete-guide/ 
-- 
-- OriginalFilename is the filename used when this was shared in another app
-- Filename is the IOS converted filename after the above image was saved on the device(iPhone)
--
-- Z_PK = Primary Key (unique identifier) for the entity,
-- Z_ENT = is the entity ID (every entity of a particular type has the same entity ID)
-- Z_OPT = number of times an entity has been changed
--
-- https://linuxsleuthing.blogspot.com/2013/05/ios6-photo-streams-recover-deleted.html
-- https://discussions.apple.com/thread/8184861 

select 
	case zgenericasset.ZSAVEDASSETTYPE
			when 0 then 'Saved from other source'
			when 2 then 'Photo Streams Data'
			when 3 then 'Made/saved with this device'
			when 4 then 'Default row'
			when 7 then 'Deleted'
			else zgenericasset.ZSAVEDASSETTYPE
			end as 'AssetType',
	zgenericasset.ZDIRECTORY as 'Directory',
	zgenericasset.ZFILENAME as 'FileName',
	ZADDITIONALASSETATTRIBUTES.ZORIGINALFILENAME as 'OriginalFilename',
	ZADDITIONALASSETATTRIBUTES.ZORIGINALFILESIZE as 'OriginalSize',
	zgenericasset.ZORIGINALCOLORSPACE as 'ColorSpace',
	zgenericasset.ZUNIFORMTYPEIDENTIFIER as 'FormType',
	ZSIDECARFILE.ZFILENAME as ' SidecarFilename',
	ZSIDECARFILE.ZORIGINALFILENAME as 'SidecarOriginalF',
	ZSIDECARFILE.ZCOMPRESSEDSIZE as ' CompressedSize',
	ZSIDECARFILE.ZUNIFORMTYPEIDENTIFIER as 'SidecarFormType',
	ZIMAGEURLDATA as 'ImageURLdata',
	ZTHUMBNAILURLDATA as 'ThumbnailURLdata',
	case zgenericasset.ZLATITUDE 
		when -180.0
		then ''
		else zgenericasset.ZLATITUDE
		end as ' Latitude',
	case zgenericasset.ZLONGITUDE 
		when -180.0
		then ''
		else zgenericasset.ZLONGITUDE
		end as ' Longitude',
	case ZCLOUDDOWNLOADREQUESTS
		when 0 then 'No'
		when 1 then 'Yes'
		end as 'CLOUDDOWNLOADREQUESTS',
	case ZCLOUDISDELETABLE 
			when 1 then 'Yes'
			end as 'CLOUDISDELETABLE',
	case ZCLOUDISMYASSET  
			when 1 then 'Yes'
			end as 'CLOUDISMYASSET',
	case ZCLOUDLOCALSTATE 
		when 0 then 'Local'
		when 1 then 'Remote'
		end as 'CLOUDLOCALSTATE',		
	case ZFAVORITE   
			when 0 then 'No'
			when 1 then 'Yes'
			end as 'Favorite',		
	case ZHASADJUSTMENTS    
			when 0 then 'No'
			when 1 then 'Yes'
			end as 'Modified',
	ZWIDTH||' x '||ZHEIGHT as 'Dimenasions(WxH)',
	ZADDITIONALASSETATTRIBUTES.ZEMBEDDEDTHUMBNAILWIDTH||' x '||ZADDITIONALASSETATTRIBUTES.ZEMBEDDEDTHUMBNAILHEIGHT as 'EmbeddedThumbnail(WxH)',
	ZADDITIONALASSETATTRIBUTES.ZEMBEDDEDTHUMBNAILOFFSET as 'EmbeddedThumbnailOffset',
	ZADDITIONALASSETATTRIBUTES.ZEMBEDDEDTHUMBNAILLENGTH as 'ETNLength',
	time(ZDURATION,'unixepoch') as 'Duration',
	time(zgenericasset.ZVIDEOCPDURATIONVALUE,  'unixepoch') as 'CPDuration',
	case ZORIENTATION    
			when 1 then 'Horizontal (left)'
			when 3 then 'Horizontal (right)'
			when 6 then 'Vertical (up)'
			when 8 then 'Vertical (down)'
			else ZORIENTATION
			end as 'Orientation',
	case ZKIND    
			when 0 then 'Photo'
			when 1 then 'Video'
			end as 'Kind',
	case ZKINDSUBTYPE    
			when 0 then 'Normal'
			when 1 then 'Panorama'
			when 100 then 'Default row'
			when 101 then 'Slo-mo'
			when 102 then 'Timelapse'
			else ZKINDSUBTYPE
			end as 'SubType',
	case zgenericasset.ZTRASHEDSTATE     
			when 1 then 'Deleted'
			when 0 then 'Not Deleted'
			else zgenericasset.ZTRASHEDSTATE
			end as 'TrashState',
	datetime('2001-01-01', ZTRASHEDDATE || ' seconds') as 'TrashedDate',
	case ZCOMPLETE  
			when 1 then 'Yes'
			end as 'Complete',		
	case ZVISIBILITYSTATE     
			when 0 then 'Visible'
			when 1 then 'Photo Streams Data'
			when 2 then 'Burst'
			else ZVISIBILITYSTATE
			end as 'VisibilityState',
	ZADDITIONALASSETATTRIBUTES.ZCREATORBUNDLEID as 'CreatorBundleID',
	ZADDITIONALASSETATTRIBUTES.ZEDITORBUNDLEID as 'EditorBundleID',
	ZUNMANAGEDADJUSTMENT.ZADJUSTMENTFORMATIDENTIFIER||' ('||ZUNMANAGEDADJUSTMENT.ZADJUSTMENTFORMATVERSION||')' as 'AdjustmentFormatIdentifier',
	datetime('2001-01-01', ZSIDECARFILE.ZCAPTUREDATE || ' seconds') as 'SidecarCaptudeDate',
	datetime('2001-01-01', ZSIDECARFILE.ZMODIFICATIONDATE || ' seconds') as 'SidecarModificationDate',
	datetime('2001-01-01', ZUNMANAGEDADJUSTMENT.ZADJUSTMENTTIMESTAMP || ' seconds') as 'AdjustmentTimestamp',
	datetime('2001-01-01', zgenericasset.ZFACEADJUSTMENTVERSION || ' seconds') as 'FaceAdjustmentVersion',
	datetime('2001-01-01', ZGENERICASSET.ZMODIFICATIONDATE || ' seconds') as 'ModificationDate',
	datetime('2001-01-01', ZADDEDDATE || ' seconds') as 'AddedDate',
	datetime('2001-01-01', ZDATECREATED || ' seconds') as 'CreatedDate',
	ZADDITIONALASSETATTRIBUTES.ZEXIFTIMESTAMPSTRING as 'EXIFtimestamp',
	datetime('2001-01-01', ZMOMENT.ZSTARTDATE || ' seconds') as 'MomentStartDate',
	datetime('2001-01-01', ZMOMENT.ZENDDATE || ' seconds') as 'MomentEndDate',
	datetime('2001-01-01', zgenericasset.ZLASTSHAREDDATE || ' seconds') as 'LastSharedDate',
	ZADDITIONALASSETATTRIBUTES.ZTIMEZONENAME||' ('||ZADDITIONALASSETATTRIBUTES.ZTIMEZONEOFFSET||')' as 'TimeZone',
	ZMOMENT.ZAPPROXIMATELOCATIONDATA as 'ApproximateLocationData(bplist)',	
	ZMOMENT.ZREVERSELOCATIONDATA as 'ReverseLocationData0(bplist)',	
	case ZMOMENT.ZREVERSELOCATIONDATAISVALID 
		when 0 then 'No'
		when 1 then 'Yes'
		end as 'LocationValid',	
	ZMOMENTLIST.ZREVERSELOCATIONDATA as 'ReverseLocationData1(bplist)',		
	case ZMOMENTLIST.ZREVERSELOCATIONDATAISVALID 
		when 0 then 'No'
		when 1 then 'Yes'
		end as 'LocationValid',
	ZADDITIONALASSETATTRIBUTES.ZREVERSELOCATIONDATA as 'ReverseLocationData2(bplist)',
	case ZADDITIONALASSETATTRIBUTES.ZSHIFTEDLOCATIONISVALID -- Field does not exist in IOS 8.3
		when 0 then 'No'
		when 1 then 'Yes'
		end as 'ShiftedLocationValid'
from zgenericasset
	join Z_PRIMARYKEY on zgenericasset.z_ent = Z_PRIMARYKEY.z_ent
	left join ZMOMENTLIST on zgenericasset.ZMOMENT = ZMOMENTLIST.Z_PK
	left join ZMOMENT on ZGENERICASSET."ZMOMENT" = ZMOMENT.Z_PK
	join ZADDITIONALASSETATTRIBUTES on ZGENERICASSET.ZADDITIONALATTRIBUTES = ZADDITIONALASSETATTRIBUTES.Z_PK
	left join ZUNMANAGEDADJUSTMENT on ZADDITIONALASSETATTRIBUTES."ZUNMANAGEDADJUSTMENT" = ZUNMANAGEDADJUSTMENT.Z_PK
	left join ZSIDECARFILE on ZSIDECARFILE.ZASSET = ZGENERICASSET.Z_PK
order by CreatedDate desc
-- Note: Table "Z_RT_GenericAsset_boundedByRect" is not querable but containts location info