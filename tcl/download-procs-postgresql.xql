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
      FIX ME LOB
select content
                                 from   cr_revisions
                                 where  revision_id = $revision_id
      </querytext>
</fullquery>

 
<fullquery name="download_insert_revision.revision_new">      
      <querytext>
      FIX ME PLSQL

        declare
          v_revision_id integer;
        begin
          v_revision_id := content_revision__new(
           item_id => :archive_id,
           title => :filename,
           description => :version_name,
           revision_id => :revision_id,
           mime_type => :mime_type,
           creation_user => :user_id,
           creation_ip => :creation_ip
          );

          insert into download_archive_revisions (revision_id,    approved_p) values
                                                 (v_revision_id, :approved_p);
        end;
    
      </querytext>
</fullquery>

 
<fullquery name="download_insert_revision.content_add">      
      <querytext>
      FIX ME LOB

        update cr_revisions
        set    content = empty_blob()
        where  revision_id = :revision_id
        returning content into :1
    
      </querytext>
</fullquery>

 
<fullquery name="download_insert_revision.make_live">      
      <querytext>
      FIX ME PLSQL

        begin
        content_item__set_live_revision(:revision_id);
        end;
    
      </querytext>
</fullquery>

 
</queryset>
