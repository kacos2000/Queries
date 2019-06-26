-- IOS11 - WhatsApp messages - \Application Groups\net.whatsapp.WhatsApp.shared\ChatStorage.sqlite
-- net.whatsapp.WhatsApp 2.17.52.40

Select 
zwamessage.z_pk as 'pk',
zwamessage.ZMESSAGETYPE as 'Type',
datetime('2001-01-01', zwamessage.ZMESSAGEDATE || ' seconds') as 'MessageDate',
ZWACHATSESSION.ZPARTNERNAME as 'SessionPartnerName',
zwamessage.ZFROMJID as 'From',
case zwamessage.ZISFROMME
	when 0 then zwamessage.ZTEXT 
	end as 'Incoming Message',
case zwamessage.ZISFROMME
	when 1 then zwamessage.ZTEXT 
	end as 'Outgoing Message',
zwamessage.ZTOJID as 'Sent To',	
datetime('2001-01-01', zwamessage.ZSENTDATE || ' seconds') as 'SentDate',
zwamessage.ZMEDIASECTIONID as 'MediaDate',
ZWAMEDIAITEM.ZMEDIALOCALPATH as 'Path',
ZWAMEDIAITEM.ZVCARDSTRING as 'MediaType',
time(ZWAMEDIAITEM.ZMOVIEDURATION,'unixepoch') as 'Duration',
ZWAMEDIAITEM.ZMEDIAURL as 'Media_URL',
datetime('2001-01-01', ZWAMEDIAITEM.ZMEDIAURLDATE || ' seconds') as 'UrlDate',
ZWAMEDIAITEM.ZTITLE as 'Media_Title',
ZWAMEDIAITEM.ZLONGITUDE as 'Longitude',
ZWAMEDIAITEM.ZLATITUDE as 'Latitude',
ZWAMEDIAITEM.ZFILESIZE as 'Size',
zwamessage.ZPUSHNAME as 'PushName(To)',
ZWAMESSAGEINFO.ZRECEIPTINFO as 'ReceiptInfo(BLOOB)'

from zwamessage 
left join ZWACHATSESSION on zwamessage.ZCHATSESSION = ZWACHATSESSION.Z_PK
left join ZWAPROFILEPUSHNAME on zwamessage.ZPUSHNAME = ZWAPROFILEPUSHNAME.ZPUSHNAME
left join ZWAMEDIAITEM on ZWAMEDIAITEM.ZMESSAGE = zwamessage.Z_PK
left join ZWAMESSAGEINFO on ZWAMESSAGEINFO.ZMESSAGE = zwamessage.Z_PK

order by MessageDate desc