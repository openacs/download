<?xml version="1.0"?>
<queryset>

<fullquery name="repository_types_insert">      
      <querytext>
      
        insert into download_archive_types (archive_type_id, repository_id, pretty_name, description) values (:archive_type_id, :repository_id, :pretty_name, :description)
    
      </querytext>
</fullquery>

 
<fullquery name="types_select">      
      <querytext>
      
    select archive_type_id, pretty_name, description from download_archive_types where repository_id = :repository_id

      </querytext>
</fullquery>

 
</queryset>
