select 
	case cloud_entry.acl_role
		when 2 then 'Can View'
		when 1 then 'Can Contribute'
		when 0 then 'Private'
	else cloud_entry.acl_role 
	end as acl_role,
	case cloud_entry.doc_type
		when 0 then 'Folder'
		when 1 then 'File'
		when 4 then 'Google Spreadsheet'
		when 6 then 'Google Document'
		when 12 then 'Google My Maps'
		else cloud_entry.doc_type
	end as doc_type,
	(select filename from cloud_entry where cloud_entry.doc_id = cloud_relations.parent_doc_id) as 'CloudParent',
	cloud_entry.filename as 'Cloud_Filename',
	cloud_entry.checksum as 'Cloud_MD5_Hash',
	datetime(cloud_entry.modified, 'unixepoch','localtime') as 'Cloud_Modified',
	cloud_entry.size as 'Cloud_Size',
	cloud_entry.original_size as 'Original Size',
	case cloud_entry.removed 
		when 0 then 'No' 
		when 1 then 'Yes' 
	end as 'Removed' ,
	case cloud_entry.shared 
		when 0 then 'No' 
		when 1 then 'Yes' 
	end as 'Shared',
	case local_entry.is_folder 
		when 0 then 'No' 
		when 1 then 'Yes' 
	end as 'Is_Folder',
	(select filename from local_entry where local_entry.inode = local_relations.parent_inode) as 'LocalParent',
	local_entry.filename as 'Local_Filename',
	local_entry.size as 'Local_Size',
	local_entry.checksum as 'Local_MD5_Hash',
	datetime(local_entry.modified, 'unixepoch','localtime') as 'Local_Modified',
	case 
		when cloud_entry.checksum = local_entry.checksum 
		then 'MD5 Match' 
		else (case 
				when cloud_entry.checksum notnull 
				then 'No_Match'
				else '' 
			  end) 
	end as 'MD5_Check',
	case 
		when cloud_entry.modified = local_entry.modified 
		then 'Dates Match' 
		else 'No Match' 
	end as 'Cloud/Local_Dates Check',
	case 
		when local_entry.volume = volume_info.volume 
		then volume_info.full_path||" - "||volume_info.device_type||" - Volume Name: ("||volume_info.label||")" 
		else local_entry.volume 
	end as 'Volume',
	local_relations.child_volume as 'Child_Volume',
	local_relations.parent_volume as 'Parent_Volume'

from cloud_entry
join mapping on cloud_entry.doc_id = mapping.doc_id
join cloud_relations on cloud_entry.doc_id = cloud_relations.child_doc_id
join local_entry on local_entry.inode = mapping.inode
join local_relations on local_relations.child_inode = local_entry.inode
left join volume_info on volume_info.volume = local_entry.volume
--order by Local_Modified desc