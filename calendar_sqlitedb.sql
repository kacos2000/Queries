-- \Home\Library\Calendar\Calendar.sqlitedb

-- Z_PK = Primary Key (unique identifier) for the entity,
-- Z_ENT = is the entity ID (every entity of a particular type has the same entity ID)
-- Z_OPT = number of times an entity has been changed

Select 
store.name as 'StoreName',
Calendar.title||' ('||calendaritem.calendar_id||')' as 'Title',
calendaritem.summary,
calendaritem.description,
-- calendaritem.conference, -- Does not exist in IOS 11
datetime('2001-01-01', calendaritem.creation_date || ' seconds') as 'CreationDate',
case 
	when calendaritem.start_tz != '_float'
	then calendaritem.start_tz
	else 'floating'
	end as StartTimezone,
datetime('2001-01-01', calendaritem.start_date || ' seconds') as 'StartDate',
case 
	when calendaritem.end_tz != '_float'
	then calendaritem.end_tz
	else 'floating'
	end as EndTimezone,
datetime('2001-01-01', calendaritem.end_date || ' seconds') as 'EndDate',
calendaritem.calendar_scale as 'Scale',
case calendaritem.all_day
	when 0 then 'No'
	when 1 then 'Yes'
	end as 'AllDay',
case 
	when calendaritem.organizer_id != 0
	then calendaritem.organizer_id
	end as 'OrganizerID',
case 
	when calendaritem.self_attendee_id != 0
	then calendaritem.self_attendee_id
	end as 'SelfAttendeeID',
case Participant.is_self
	when 1 	then 'Yes'
	end as 'IsSelf',	
Participant.email as 'OrganizerEmail',
case calendaritem.has_recurrences
	when 1 then 'Yes'
	end as 'IsRecurring',
datetime('2001-01-01', calendaritem.due_date || ' seconds') as 'DueDate',
case calendaritem.due_all_day
	when 1 then 'Yes'
	end as 'DueAllDay',
datetime('2001-01-01', calendaritem.shared_item_created_date || ' seconds') as 'SharedItemCreatedDate',	
datetime('2001-01-01', calendaritem.shared_item_modified_date || ' seconds') as 'SharedItemModifiedDate',
Location.title as 'LocationTitle',
Location.address as 'LocationAddress',
Location.latitude,  -- The latitude in degrees.
Location.longitude, -- The longitude in degrees.
Location.radius||' m' as 'radius', -- The radius of uncertainty for the location, measured in meters.
Location.item_owner_id, -- ROWID of ABperson table @ Contacts db
Location.address_book_id,
Location.alarm_owner_id,
Calendar.notes,
Calendar.shared_owner_name,
-- Calendar.shared_owner_email, -- Does not exist in IOS 11
Calendar.external_id

from calendaritem
left join Location on Location.ROWID = CalendarItem.location_id
left join Participant on Participant.ROWID = calendaritem.organizer_id
left join Calendar on Calendar.ROWID = CalendarItem.calendar_id
left join Store on Store.ROWID = Calendar.store_id
