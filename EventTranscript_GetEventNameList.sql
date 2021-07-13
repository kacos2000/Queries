-- List unigue Event Names from
-- from C:\ProgramData\Microsoft\Diagnosis\EventTranscript\EventTranscript.db

SELECT

distinct events_persisted.full_event_name

from events_persisted
order by events_persisted.full_event_name asc