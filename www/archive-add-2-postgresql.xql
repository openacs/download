<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="archive_new">      
      <querytext>
        declare
          v_archive_id 			  integer;
          v_archive_desc_id 	  integer;
		  v_live_archive_desc_id  integer;
		  v_id			  		  integer;
          v_name       			  cr_items.name%TYPE;
        begin
          v_name := 'Download Archive Desc for ' || :archive_id;

          v_archive_desc_id := content_item__new (
			v_name,
			:repository_id,
			:archive_desc_id,
			null,
			now(),
			:user_id,
			:repository_id,
			:creation_ip,
			'content_item',
			'cr_download_archive_desc',
			:summary,
			:description,
			:description_format,
			null,
			null,
			'file'
          );

		  -- get the latest revision
	 	  select into v_live_archive_desc_id 
			content_item__get_latest_revision (v_archive_desc_id);

	 	  -- make it live
	 	  select into v_id 
			content_item__set_live_revision ( v_live_archive_desc_id );
			
          insert into download_archive_descs 
			(archive_desc_id) 
			values 
			(v_live_archive_desc_id);

          v_archive_id := content_item__new(
			:archive_name,
			:repository_id,
			:archive_id,
			null,
			now(),
			:user_id,
			:repository_id,
			:creation_ip,
			'content_item',
			'cr_download_archive',
			null,
			null,
			'text/plain',
			null,
			null,
			'file'
		  );

		  -- get the latest revision
	 	  select into v_id 
			content_item__get_latest_revision (v_archive_id);

	 	  -- make it live
	 	  select into v_id 
			content_item__set_live_revision ( v_id );
			
          insert into download_archives 
			(archive_id, archive_type_id, archive_desc_id) 
			values 
			(v_archive_id, :archive_type_id, v_live_archive_desc_id);

		  return 0;
        end;
    
      </querytext>
</fullquery>

 
</queryset>
