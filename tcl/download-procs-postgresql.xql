<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="download_file_downloader.download_insert">      
      <querytext>
      
                insert into download_downloads (
                download_id, 
                user_id, 
                revision_id, 
                download_date, 
                download_ip,
                download_hostname,
                user_agent,
                reason_id,
                reason)
                values
                (:download_id, 
                :user_id, 
                :revision_id, 
                current_timestamp, 
                :download_ip,
                :download_hostname,
                :user_agent,
                :reason_id,
                :reason_other)
            
      </querytext>
</fullquery>

 
<fullquery name="download_file_downloader.version_write">      
      <querytext>
select '[cr_fs_path]' || content as content, storage_type
                                 from   cr_revisions
                                 where  revision_id = :revision_id
      </querytext>
</fullquery>

 
<fullquery name="download_insert_revision.revision_new">      
      <querytext>

        declare
          v_revision_id integer;
        begin
          v_revision_id := content_revision__new(
			:filename,
			:version_name,
			now(),
			:mime_type,
			null,
			' ',
			:archive_id,
			:revision_id,
			now(),
			:user_id,
			:creation_ip
		  );

          insert into download_archive_revisions (revision_id,    approved_p) values
                                                 (v_revision_id, :approved_p);
		  return v_revision_id;
        end;
    
      </querytext>
</fullquery>

 
<fullquery name="download_insert_revision.content_add">      
      <querytext>

        update cr_revisions
        set    content = '[cr_create_content_file $item_id $revision_id $tmp_filename]'
        where  revision_id = :revision_id
    
      </querytext>
</fullquery>

 
<fullquery name="download_insert_revision.make_live">      
      <querytext>

        begin
	        content_item__set_live_revision(:revision_id);
	
			return 0;
        end;
    
      </querytext>
</fullquery>

 
</queryset>
