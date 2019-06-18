select 
-- iPhone 7 (9.3.1)

sources.name,
case datatype_source_order.data_type -- https://www.sans.org/cyber-security-summit/archives/file/summit-archive-1528385073.pdf
	when 3 then 'Weight'
	when 5 then 'Heart Rate'
	when 7 then 'Steps'
	when 8 then 'Distance'
	when 9 then 'Resting Energy'
	when 10 then 'Active Energy'
	when 12 then 'Flights Climbed'
	when 67 then 'Weekly Calorie Goal'
	when 70 then 'Watch On'
	when 75 then 'Standing' 
	when 76 then 'Activity'
	when 79 then 'Workout'
	when 83 then 'Some workouts'
	else datatype_source_order.data_type -- 20’s ~ 30’s = Nutrition
	end as 'DataType',
subscription_data_anchors.last_anchor,
datatype_source_order.ROWID,
datatype_source_order.user_preferred,
datatype_source_order.provenance

from datatype_source_order
join sources on datatype_source_order.source = sources.ROWID
join subscription_data_anchors on subscription_data_anchors.code = datatype_source_order.data_type