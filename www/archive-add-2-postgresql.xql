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
          v_archive_name                  cr_items.name%TYPE;
        begin
          v_name := 'Download Archive Desc for ' || :archive_id;

          v_archive_desc_id := content_item__new (
                        v_name,                     -- name
                        :repository_id,             -- parent_id
                        :archive_desc_id,           -- item_id
                        null,                       -- locale
                        now(),                      -- creation_date
                        :user_id,                   -- creation_user
                        :repository_id,             -- context_id
                        :creation_ip,               -- creation_ip
                        'content_item',             -- item_subtype
                        'cr_download_archive_desc', -- content_type
                        :summary,                   -- title
                        :description,               -- description
                        :description_format,        -- mime_type
                        null,                       -- nls_language
                        null,                       -- text
                        null,                       -- data
			null,                       -- relation_tag
			'f',                        -- is_live
                        'file',                     -- storage_type
                        :package_id                 -- package_id
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
                        varchar :archive_name,      -- name
                        :repository_id,             -- parent_id
                        :archive_id,                -- item_id
                        null,                       -- locale
                        now(),                      -- creation_date
                        :user_id,                   -- creation_user
                        :repository_id,             -- context_id
                        :creation_ip,               -- creation_ip
                        'content_item',             -- item_subtype
                        'cr_download_archive',      -- content_type
                        null,                       -- title
                        null,                       -- description
                        'text/plain',               -- mime_type
                        null,                       -- nls_language
                        null,                       -- text
                        null,                       -- data
			null,                       -- relation_tag
			'f',                        -- is_live
                        'file',                     -- storage_type
                        :package_id                 -- package_id
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
