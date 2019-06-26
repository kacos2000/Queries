-- IOS 11, Hike Sticker Chat (v1004)
-- \Application Groups\com.bsb.hike
--
-- https://www.apkmonk.com/app/com.bsb.hike/
-- https://appagg.com/ios/social-networking/hike-sticker-chat-4258789.html?hl=en


Select 
z_primarykey.Z_NAME as 'Type' ,
datetime('2001-01-01', zbsbmessage.ZTIMESTAMP|| ' seconds') as 'mTimeStamp',
zbsbchat.ZIDENTIFIER as 'ChatId',
zbsbchat.ZTITLE as 'ChatTitle',
case zbsbmessage.ZINCOMING
	when 1 then zbsbmessage.ZTEXT
	end as 'IncomingMessage',
case zbsbmessage.ZINCOMING
	when 0 then zbsbmessage.ZTEXT
	end as 'OutgoingMessage',
datetime('2001-01-01', zbsbchat.ZLASTACTIVITY|| ' seconds') as 'ChatLastActivity'

from zbsbmessage 
join zbsbchat on zbsbmessage.ZCHAT = zbsbchat.Z_PK
join z_primarykey on zbsbmessage.Z_ENT = z_primarykey.Z_ENT

order by mTimeStamp desc