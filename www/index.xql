<?xml version="1.0"?>
<queryset>

<fullquery name="archive_type">      
      <querytext>
      
    select archive_type_id as at_id, pretty_name from download_archive_types where repository_id = :repository_id

      </querytext>
</fullquery>

 
<fullquery name="metadata">      
      <querytext>
      
    select dam.metadata_id,
           dam.pretty_name,
           dam.data_type,
           dam.linked_p
    from download_archive_metadata dam
    where dam.mainpage_p = 't' and
          dam.repository_id = :repository_id and
          (dam.archive_type_id = :archive_type_id or dam.archive_type_id is null)
    order by sort_key

      </querytext>
</fullquery>

 
<fullquery name="types_select">      
      <querytext>
      
    select archive_type_id, pretty_name, description from download_archive_types where repository_id = :repository_id

      </querytext>
</fullquery>

 
</queryset>
