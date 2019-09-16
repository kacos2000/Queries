-- "\private\var\mobile\Library\CoreDuet\Knowledge\knowledgeC.db"


Select 
	ZOBJECT.z_pk,
	Z_PRIMARYKEY.Z_NAME,
	ZOBJECT.ZSTREAMNAME,
	ZOBJECT.ZSTRING,
	zobject.ZDOUBLEVALUE as 'Quantity',
	zobject.ZVALUEDOUBLE as 'Value',
	time (ZOBJECT.ZENDSECONDOFDAY-ZOBJECT.ZSTARTSECONDOFDAY, 'unixepoch') as 'Duration',
	ZOBJECT.ZSECONDSFROMGMT/3600 as 'GMT offset',
	datetime('2001-01-01', ZOBJECT.ZCREATIONDATE || ' seconds') as 'Created',
	datetime('2001-01-01', ZOBJECT.ZSTARTDATE || ' seconds') as 'Started',
	case ZOBJECT.ZSTARTDAYOFWEEK
		when 1 then 'Sunday'
		when 2 then 'Monday'
		when 3 then 'Tuesday'
		when 4 then 'Wednesday'
		when 5 then 'Thursday'
		when 6 then 'Friday'
		when 7 then 'Saturday'
	end as 'Start_Day',
	time(ZOBJECT.ZSTARTSECONDOFDAY, 'unixepoch') as 'Start time',
	datetime('2001-01-01', ZOBJECT.ZENDDATE || ' seconds') as 'Ended',
	case ZOBJECT.ZENDDAYOFWEEK
		when 1 then 'Sunday'
		when 2 then 'Monday'
		when 3 then 'Tuesday'
		when 4 then 'Wednesday'
		when 5 then 'Thursday'
		when 6 then 'Friday'
		when 7 then 'Saturday'
	end as 'End_Day',
	time(ZOBJECT.ZENDSECONDOFDAY, 'unixepoch') as 'End time',
	ZOBJECT.zmetadata as 'Metadata(bplist)'
	from zobject
	join z_primarykey on z_primarykey.z_ent = zobject.z_ent
	order by ZOBJECT.ZCREATIONDATE desc