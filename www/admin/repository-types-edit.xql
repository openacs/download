<?xml version="1.0"?>
<queryset>

<fullquery name="edit_info">      
      <querytext>
      select archive_type_id, pretty_name, description from download_archive_types where archive_type_id = :archive_type_id
      </querytext>
</fullquery>

 
<fullquery name="edit_type">      
      <querytext>
      
        update download_archive_types set pretty_name = :pretty_name, description = :description
        where archive_type_id = :archive_type_id
    
      </querytext>
</fullquery>

 
</queryset>
