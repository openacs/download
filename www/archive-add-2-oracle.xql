<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="archive_new">      
      <querytext>
      
        declare
          v_archive_id integer;
          v_archive_desc_id integer;
          v_name       cr_items.name%TYPE;
        begin
          v_name := 'Download Archive Desc for ' || :archive_id;

          v_archive_desc_id := content_item.new (
           content_type => 'cr_download_archive_desc',
           item_id => :archive_desc_id,
           name => v_name,
           title => :summary,
           description => :description,
           mime_type => :description_format,
           parent_id => :repository_id,
           context_id => :repository_id,
           creation_user => :user_id,
           creation_ip => :creation_ip,
           is_live => 't'
          );
          insert into download_archive_descs (archive_desc_id) values (content_item.get_live_revision(v_archive_desc_id));

          v_archive_id := content_item.new(
           content_type => 'cr_download_archive',
           item_id => :archive_id,
           name => :archive_name,
           parent_id => :repository_id,
           context_id => :repository_id,
           creation_user => :user_id,
           creation_ip => :creation_ip
          );

          insert into download_archives (archive_id, archive_type_id, archive_desc_id) values (v_archive_id, :archive_type_id, content_item.get_live_revision(v_archive_desc_id));
        end;
    
      </querytext>
</fullquery>

 
</queryset>
