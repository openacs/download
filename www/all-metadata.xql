<?xml version="1.0"?>
<queryset>

<fullquery name="metadata">      
      <querytext>
      
    select dam.pretty_name,
           dam.data_type
    from download_archive_metadata dam
    where dam.linked_p = 't' and
          dam.metadata_id = :metadata_id

      </querytext>
</fullquery>

 
</queryset>
