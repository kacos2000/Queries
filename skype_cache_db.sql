select
Assets.id as 'id',
Assets.key as 'key',
Assets.sub_key as 'sub_key',
assets.lock_count as 'lock_count',
datetime(assets.access_time /10000000, 'unixepoch', 'localtime')  as 'AccessTime',
assets.actual_size as 'actual_size',
assets.reserved_size as 'reserved_size',
assets.type as 'type',
assets.owner as 'owner',
hex(assets.serialized_data) as 'serial'
from  Assets


