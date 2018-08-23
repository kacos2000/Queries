select
Assets.id,
Assets.key as 'key',
Assets.sub_key,

assets.lock_count,
datetime(assets.access_time /10000000, 'unixepoch', 'localtime')  as 'AccessTime',
assets.actual_size,
assets.reserved_size,
assets.type,
assets.owner,
hex(assets.serialized_data) as 'serial'

from  Assets
order by actual_size desc

