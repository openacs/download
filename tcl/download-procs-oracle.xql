<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

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
                sysdate, 
                :download_ip,
                :download_hostname,
                :user_agent,
                :reason_id,
                :reason_other)
            
      </querytext>
</fullquery>

 
<fullquery name="download_file_downloader.version_write">      
      <querytext>
      select content
                                 from   cr_revisions
                                 where  revision_id = :revision_id
      </querytext>
</fullquery>

 
<fullquery name="download_insert_revision.revision_new">      
      <querytext>
      
        declare
          v_revision_id integer;
        begin
          v_revision_id := content_revision.new(
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
      
        update cr_revisions
        set    content = empty_blob()
        where  revision_id = :revision_id
        returning content into :1
    
      </querytext>
</fullquery>

 
<fullquery name="download_insert_revision.make_live">      
      <querytext>
      
        begin
        content_item.set_live_revision(:revision_id);
        end;
    
      </querytext>
</fullquery>

 
</queryset>
