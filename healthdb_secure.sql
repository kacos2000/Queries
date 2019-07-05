-- iPhone 7 (9.3.1)
-- references:
--
-- ref: https://www.mac4n6.com/?offset=1544965200340
-- https://www.sans.org/cyber-security-summit/archives/file/summit-archive-1528385073.pdf
-- https://objectivebythesea.com/v1/talks/OBTS_v1_Edwards.pdf

select 
data_provenances.origin_device||' ('||data_provenances.source_version||')' as 'Device',
case samples.data_type  
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
	else samples.data_type -- 20’s ~ 30’s = Nutrition
	end as 'DataType',
quantity_samples.original_quantity||' '||unit_strings.unit_string as 'Quantity',
quantity_samples.quantity as 'Original_Quantity',
datetime('2001-01-01', samples.start_date || ' seconds') as 'StartDate',
datetime('2001-01-01', samples.end_date || ' seconds') as 'EndDate'

from samples
	left join activity_caches on activity_caches.data_id = samples.data_id
	left join quantity_samples on quantity_samples.data_id = samples.data_id
	left join correlations on samples.data_id = correlations.object
	left join data_provenances on data_provenances.ROWID = quantity_samples.original_unit 
	left join unit_strings on unit_strings.ROWID = quantity_samples.original_unit

--where data_type = 5 -- filter by heart rate
order by StartDate desc