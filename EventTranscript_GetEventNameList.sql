-- List unigue Event Names from
-- from C:\ProgramData\Microsoft\Diagnosis\EventTranscript\EventTranscript.db

SELECT

events_persisted.full_event_name,
count(events_persisted.full_event_name) as count
-- events_persisted.payload

from events_persisted
-- where events_persisted.full_event_name like '%Defender%'
group by events_persisted.full_event_name
order by events_persisted.full_event_name asc