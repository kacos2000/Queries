-- References:
--
-- https://github.com/geiszla/iOSLib/wiki/ZGENERICASSET-contents
-- https://github.com/geiszla/iOSLib/wiki/ZADDITIONALASSETATTRIBUTES-contents
-- https://forensenellanebbia.blogspot.com/2015/10/apple-ios-recently-deleted-images.html

select 
Z_PRIMARYKEY.Z_NAME as 'Type',
case zgenericasset.ZSAVEDASSETTYPE
		when 0 then 'Saved from other source'
		when 2 then 'Photo Streams Data'
		when 3 then 'Made/saved with this device'
		when 4 then 'Default row'
		when 7 then 'Deleted'
		else zgenericasset.ZSAVEDASSETTYPE
		end as 'AssetType',
ZDIRECTORY as 'Directory',
ZFILENAME as 'FileName',
ZADDITIONALASSETATTRIBUTES.ZORIGINALFILENAME as 'OriginalFilename',
ZADDITIONALASSETATTRIBUTES.ZORIGINALFILESIZE as 'OriginalSize',
ZUNIFORMTYPEIDENTIFIER as 'FormTypeIdentifier',
ZIMAGEURLDATA as 'ImageURLdata',
ZTHUMBNAILURLDATA as 'ThumbnailURLdata',
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
case zgenericasset.ZHIGHDYNAMICRANGETYPE 
	when 0 then 'No HDR'
	when 1 then 'Low'
	when 6 then 'High'
	else zgenericasset.ZHIGHDYNAMICRANGETYPE
	end as 'HDRtype', --Seen values 0, 1 and 6
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
datetime('2001-01-01', ZUNMANAGEDADJUSTMENT.ZADJUSTMENTTIMESTAMP || ' seconds') as 'AdjustmentTimestamp',
datetime('2001-01-01', ZMODIFICATIONDATE || ' seconds') as 'ModificationDate',
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
ZADDITIONALASSETATTRIBUTES.ZREVERSELOCATIONDATA as 'ReverseLocationData2(bplist)'
	
-- case ZADDITIONALASSETATTRIBUTES.ZSHIFTEDLOCATIONISVALID -- Field does not exist in IOS 8.3
--	when 0 then 'No'
--	when 1 then 'Yes'
--	end as 'ShiftedLocationValid'


from zgenericasset
join Z_PRIMARYKEY on zgenericasset.z_ent = Z_PRIMARYKEY.z_ent
left join ZMOMENTLIST on zgenericasset.ZMOMENT = ZMOMENTLIST.Z_PK
left join ZMOMENT on ZGENERICASSET."ZMOMENT" = ZMOMENT.Z_PK
join ZADDITIONALASSETATTRIBUTES on ZGENERICASSET.ZADDITIONALATTRIBUTES = ZADDITIONALASSETATTRIBUTES.Z_PK
left join ZUNMANAGEDADJUSTMENT on ZADDITIONALASSETATTRIBUTES."ZUNMANAGEDADJUSTMENT" = ZUNMANAGEDADJUSTMENT.Z_PK
order by MomentStartDate desc

