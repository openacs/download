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

 
<fullquery name="archives">      
      <querytext>
      
        select da.archive_name,
               da.archive_id,
               count(dar.revision_id) as num_versions
        from download_arch_revisions_obj dar, download_archives_obj da
        where dar.archive_id = da.archive_id and
              dar.revision_id in (select revision_id from download_revision_data where $answer_column = :value and metadata_id = :metadata_id)
        group by da.archive_name, da.archive_id

      </querytext>
</fullquery>

 
</queryset>
