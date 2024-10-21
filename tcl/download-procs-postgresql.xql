<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="download::file_downloader.download_insert">      
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
values (
  :download_id, 
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

<fullquery name="download::insert_revision.revision_new">      
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

  insert into download_archive_revisions 
  (revision_id, approved_p, file_size) 
  values
  (v_revision_id, :approved_p, :file_size);

  return v_revision_id;
end;
    
</querytext>
</fullquery>


 
<fullquery name="download::insert_revision.content_add">      
<querytext>

update cr_revisions
set    content = '[cr_create_content_file $archive_id $revision_id $tmpfile]'
where  revision_id = :revision_id
    
</querytext>
</fullquery>


 
<fullquery name="download::insert_revision.make_live">      
<querytext>

select content_item__set_live_revision( :revision_id );
    
</querytext>
</fullquery>


 
</queryset>
