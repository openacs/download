<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="metadata_select">      
      <querytext>
      
    select 
      dam.metadata_id,
      dam.repository_id,
      dam.archive_type_id,
      nvl(dat.pretty_name, 'All') as archive_name,
      dam.sort_key,
      dam.pretty_name,
      dam.data_type,
      dam.required_p,      
      dam.linked_p,        
      dam.mainpage_p,
      dam.computed_p      
    from download_archive_metadata dam, download_archive_types dat
         where dam.repository_id = :repository_id and
               dam.metadata_id = :metadata_id and
               dam.archive_type_id = dat.archive_type_id(+) 
    order by archive_type_id

      </querytext>
</fullquery>

 
</queryset>
