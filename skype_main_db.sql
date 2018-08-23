select 
Messages.id as'Mes_Id',
MediaDocuments.id,
messages.convo_id,
Conversations.displayname,
chats.participants,
Messages.from_dispname as 'From',
messages.body_xml,
Transfers.filename,
transfers.filepath,
datetime(chats.timestamp, 'unixepoch', 'localtime')  as 'ChatTimeStamp',
datetime(Conversations.last_activity_timestamp, 'unixepoch', 'localtime')  as 'last_activity_timestamp',
datetime(Messages.timestamp, 'unixepoch')  as 'MessageTimeStamp',
datetime(Messages.timestamp__ms/1000, 'unixepoch')  as 'MessageTimeStampms',
MediaDocuments.storage_document_id,
MediaDocuments.description,
MediaDocuments.type,
MediaDocuments.original_name,
MediaDocuments.thumbnail_url
from messages
left join Transfers on  Transfers.chatmsg_guid = Messages.guid
join Conversations on  Conversations.id = messages.convo_id 
left join Chats on chats.conv_dbid = messages.convo_id and Chats.type = Messages.type
left join MediaDocuments on messages.convo_id = MediaDocuments.convo_id
where Conversations.is_blocked notnull and Conversations.last_message_id notnull -- and Conversations.version notnull
order by MessageTimeStamp desc
