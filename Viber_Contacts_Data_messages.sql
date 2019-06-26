-- IOS 11 - Viber (v7.5.1.16) Messages
--
--\Application Groups\viber.share.container\database\Contacts.data

SELECT
Z_PRIMARYKEY.Z_NAME as 'Type',
datetime('2001-01-01', zvibermessage.ZDATE || ' seconds') as 'Date',
datetime('2001-01-01', zvibermessage.ZSTATEDATE || ' seconds') as 'StateDate',
ZABCONTACT.ZMAINNAME||' '||ZABCONTACT.ZPREFIXNAME as 'ContactName',
ZMEMBER.ZDISPLAYSHORTNAME as 'DisplayShortName',
ZMEMBER.ZDISPLAYFULLNAME as 'DisplayFullName',
ZPHONENUMBER.ZPHONE||' ('||ZPHONENUMBER.ZPHONETYPE||')' as  'PhoneNr',
case zvibermessage.ZSTATE
	when 'delivered'
	then zvibermessage.ZTEXT
	end as 'IncomingMessage',
case zvibermessage.ZSTATE
	when 'received'
	then zvibermessage.ZTEXT
	end as 'OutgoingMessage',
case zvibermessage.ZBEINGDELETED
		when 1 then 'Yes'
		end as 'BeingDeleted'

from zvibermessage
left join Z_PRIMARYKEY on Z_PRIMARYKEY.Z_ENT = zvibermessage.Z_ENT
left join ZCONVERSATION on ZVIBERMESSAGE.'ZCONVERSATION' = ZCONVERSATION.Z_PK
left join ZMEMBER on ZVIBERMESSAGE.Z_PK = ZMEMBER.z_pk
left join ZPHONENUMBER on ZMEMBER.Z_PK = ZPHONENUMBER.z_pk
left join z_1members on zmember.Z_PK = Z_1MEMBERS.Z_10MEMBERS
left join zabcontact on Z_1MEMBERS.Z_1ABCONTACTS = ZABCONTACT.Z_PK