<?xml version="1.0"?>
<queryset>

<fullquery name="metadata">      
      <querytext>
      
    select 
      dam.metadata_id,
      dam.pretty_name,
      dam.data_type
    from download_archive_metadata dam
         where dam.repository_id = :repository_id and
               dam.computed_p = 'f' and
               (dam.archive_type_id = :archive_type_id or
                dam.archive_type_id is null)
    order by sort_key

      </querytext>
</fullquery>

 
</queryset>
