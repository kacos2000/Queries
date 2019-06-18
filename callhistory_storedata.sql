-- IOS 8  \Home\Library\CallHistoryDB
-- References:
--
-- https://avi.alkalay.net/2011/12/iphone-call-history.html
-- https://books.google.gr/books?id=HodcDgAAQBAJ&pg=PA224&lpg=PA224&dq=zcalltype&source=bl&ots=AxN5C2eH2m&sig=ACfU3U0rLvkJ-gU-3HS9siXl54LrysrW4w&hl=en&sa=X&ved=2ahUKEwiE3p7O9e3iAhVBr6QKHT6LDTkQ6AEwEXoECAkQAQ#v=onepage&q=zcalltype&f=false

select 

z_pk as 'zpk',
ZISO_COUNTRY_CODE as 'CC',
ZADDRESS as 'Address',
ZNAME as  'Name',
ZNUMBER_AVAILABILITY as 'Nr_Availability',
case ZORIGINATED
	when 1 then 'Yes'
	end as 'Originated',
case ZANSWERED
	when 0 then 'No'
	when 1 then 'Yes'
	end as 'Answered',
case ZREAD
	when 0 then 'No'
	when 1 then 'Yes'
	end as 'Read',
ZDISCONNECTED_CAUSE as'DisconnectedCause',	
case ZCALLTYPE -- 
	when 1 then 'Standard Call'
	when 8 then 'Full AV Facetime Call'
	when 16 then 'Facetime Audio only Call'
	else ZCALLTYPE
	end as 'CallType', 
ZFACE_TIME_DATA as 'FacetimeData',
time(ZDURATION,'unixepoch') as 'Duration',
datetime('2001-01-01', zdate || ' seconds') as 'cdate',
ZDEVICE_ID as 'DeviceID',
ZUNIQUE_ID as 'UniqueID'

from zcallrecord
--where ZCALLTYPE = 8 filter by call type
order by cdate desc