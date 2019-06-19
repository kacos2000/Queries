-- IOS Home\Library\Calendar\Extras.db

Select 
Z_PRIMARYKEY.Z_NAME as 'Name',
zalarm.ZENTITYID as 'ID',
datetime('2001-01-01', zalarm.ZACKNOWLEDGEDDATE || ' seconds') as 'AcknowledgedDate',
datetime('2001-01-01', zalarm.ZENTITYDATE || ' seconds') as 'EntityDate',
zalarm.ZENTITYTIMEZONE as 'EntityTimezone',
zalarm.ZENTITYURI,
zalarm.ZEXTERNALID

From zalarm
join Z_PRIMARYKEY on Z_PRIMARYKEY.Z_ENT = zalarm.Z_ENT
order by zalarm.Z_PK desc

