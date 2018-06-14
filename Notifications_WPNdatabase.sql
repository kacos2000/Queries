select
Notification.Id,


NotificationHandler.PrimaryId as 'Application',
NotificationHandler.HandlerType,
NotificationHandler.WNSId as 'Type',
Notification.Payload,
datetime((Notification.ArrivalTime - 116444736000000000)/10000000, 'unixepoch') as ArrivalTime,
case when Notification.ExpiryTime = 0 then 'Expired' else datetime((Notification.ExpiryTime - 116444736000000000)/10000000, 'unixepoch') end as ExpiryTime,
NotificationHandler.CreatedTime,
NotificationHandler.ModifiedTime



from Notification
Join NotificationHandler on Notification.HandlerId = NotificationHandler.RecordId

--group by HandlerId
order by Id desc