Select 
	case 
		when doc_id = 'root' then 'root'
		when parent_doc_id = 'root' then 'root'
		else (select filename from cloud_graph_entry where parent_doc_id = doc_id) 
	end as Parent,
	Filename,
	size,
	checksum as MD5,
	case doc_type
		when 0 then 'Folder'
		when 1 then 'File'
		when 4 then 'Google Spreadsheet'
		when 6 then 'Google Document'
		when 12 then 'Google My Maps'
		else doc_type
	end as doc_type,
	case shared
		when 0 then ''
		when 1 then 'Yes'
	end as shared,
	datetime(modified,'unixepoch','localtime') as modified,
	version,
	case acl_role
		when 2 then 'Can View'
		when 1 then 'Can Contribute'
		when 0 then 'Private'
		else acl_role 
	end as acl_role,
	case download_restricted
		when 0 then ''
		when 1 then 'Yes'
		else download_restricted
	end as download_restricted,
	photos_storage_policy,
	down_sample_status,
	doc_id,
	cloud_relations.parent_doc_id

From cloud_graph_entry
left join cloud_relations on cloud_graph_entry.doc_id = cloud_relations.child_doc_id
order by modified desc
