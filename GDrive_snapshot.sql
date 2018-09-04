select 
mapping.doc_id as 'Doc_ID',
cloud_entry.doc_type as 'Doc_Type',
cloud_entry.filename as 'Cloud_Filename',
cloud_entry.checksum as 'Cloud_MD5_Hash',
datetime(cloud_entry.modified, 'unixepoch','localtime') as 'Cloud_Modified',
cloud_entry.size as 'Cloud_Size',
cloud_entry.original_size as 'Original Size',
case local_entry.is_folder when 0 then 'No' when 1 then 'Yes' end as 'Is_Folder',
case cloud_entry.removed when 0 then 'No' when 1 then 'Yes' end as 'Removed' ,
case cloud_entry.shared when 0 then 'No' when 1 then 'Yes' end as 'Shared',
local_entry.filename as 'Local_Filename',
local_entry.size as 'Local_Size',
local_entry.checksum as 'Local_MD5_Hash',
datetime(local_entry.modified, 'unixepoch','localtime') as 'Local_Modified',
case when local_entry.volume = volume_info.volume then volume_info.full_path||" - "||volume_info.device_type||" - Volume Name: ("||volume_info.label||")" else local_entry.volume end as 'Volume',
case when cloud_entry.checksum = local_entry.checksum then 'MD5 Match' else (case when cloud_entry.checksum notnull then 'No_Match'else null end) end as 'MD5_Check',
case when cloud_entry.modified = local_entry.modified then 'Dates Match' else 'No Match' end as 'Dates Check',
local_relations.child_volume as 'Child_Volume',
local_relations.parent_volume as 'Parent_Volume'



from cloud_entry
join mapping on cloud_entry.doc_id = mapping.doc_id
join cloud_relations on cloud_entry.doc_id = cloud_relations.child_doc_id
join local_entry on local_entry.inode = mapping.inode
join local_relations on local_relations.child_inode = local_entry.inode
left join volume_info on volume_info.volume = local_entry.volume
order by Local_Modified desc