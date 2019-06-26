-- \Home\Library\SMS\sms.db

-- Z_PK = Primary Key (unique identifier) for the entity,
-- Z_ENT = is the entity ID (every entity of a particular type has the same entity ID)
-- Z_OPT = number of times an entity has been changed

select 

case when message."date" != 0 then datetime('2001-01-01', message."date" || ' seconds') end as 'MessageDate',
case when message.date_delivered != 0 then datetime('2001-01-01', message.date_delivered || ' seconds') end as 'DateDelivered',
case when message.date_read != 0 then datetime('2001-01-01', message.date_read || ' seconds') end as 'DateRead',
case when message.date_played != 0 then datetime('2001-01-01', message.date_played || ' seconds') end as 'DatePlayed',
handle.country,
handle.id,
message.handle_id as 'handleID',
message.other_handle as 'OtherID',
handle.service,
chat.account_login,
case message.is_from_me
	when 1 then 'Yes'
	end as 'FromME',
case message.is_from_me
	when 1 then message.text
	end as 'MyText',
case message.is_from_me
	when not 1 then message.text
	end as 'RemoteText',
message.attributedBody as 'attributedBody(BLOB)',
chat.display_name,
case message.cache_has_attachments
	when 1 then 'yes'
	end as 'CacheHasAttachments',
case attachment.is_outgoing 
	when 0 then 'Incoming'
	when 1 then 'Outgoing'
	end as 'AttachmentDirection',
attachment.filename,
attachment.transfer_name,
attachment.total_bytes,
attachment.mime_type,
datetime('2001-01-01', attachment.created_date|| ' seconds') as 'CreatedDate',
attachment.uti,
attachment.transfer_state,	-- observed values 5 (temp folder) & 6 (Library)
attachment.user_info as 'AttachmentUserInfo(bplist)', 
chat.room_name,
chat.chat_identifier,	
chat.last_addressed_handle,
case message.is_delivered
	when 0 then 'No'
	when 1 then 'yes'
	end as 'is_delivered',
case message.was_data_detected
	when 1 then 'yes'
	end as 'was_data_detected',	
message.item_type,
	
case message.is_empty
	when 1 then 'yes'
	end as 'is_empty',
case message.is_archive
	when 1 then 'yes'
	end as 'is_archive',	
case message.is_finished
	when 1 then 'yes'
	end as 'is_finished',
case message.is_audio_message
	when 1 then 'yes'
	end as 'is_audio_message',
case message.is_delayed
	when 1 then 'yes'
	end as 'is_delayed',
case message.is_emote
	when 1 then 'yes'
	end as 'is_emote',	
	
chat.properties as 'ChatProperties(bplist)',
message.guid as 'MessageGUID',
chat.account_id,
chat.group_id

from message
left join handle on message.handle_id = handle.ROWID or message.other_handle = handle.ROWID
join chat_message_join on chat_message_join.message_id = message.ROWID
left join message_attachment_join on message.ROWID = message_attachment_join.message_id --A message can have multiple attachments 
left join attachment on attachment.ROWID = message_attachment_join.attachment_id
join chat on chat_message_join.chat_id = chat.ROWID



order by message.ROWID desc