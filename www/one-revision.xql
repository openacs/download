<?xml version="1.0"?>
<queryset>

<fullquery name="get_archive_type">      
      <querytext>
      select archive_type_id from download_arch_revisions_obj dar, download_archives da where dar.archive_id = da.archive_id and dar.revision_id = :revision_id
      </querytext>
</fullquery>

 
<fullquery name="metadata">      
      <querytext>
      
    select dam.metadata_id,
           dam.pretty_name,
           dam.data_type
    from download_archive_metadata dam
    where dam.repository_id = :repository_id and
          (dam.archive_type_id = :archive_type_id or dam.archive_type_id is null)
    order by sort_key

      </querytext>
</fullquery>

 
</queryset>
