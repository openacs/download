<?xml version="1.0"?>
<queryset>

<fullquery name="name_select">      
      <querytext>
      
    select da.archive_name from download_archives_obj da where da.archive_id = :archive_id

      </querytext>
</fullquery>

 
<fullquery name="count_select">      
      <querytext>
      select count(*)
from   download_downloads d, download_arch_revisions_obj dar
where  dar.archive_id = :archive_id and
       d.revision_id = dar.revision_id 
       [ad_dimensional_sql $dimensional where]

      </querytext>
</fullquery>

 
<fullquery name="count_select">      
      <querytext>
      select count(*)
from   download_downloads d, download_arch_revisions_obj dar
where  dar.archive_id = :archive_id and
       d.revision_id = dar.revision_id 
       [ad_dimensional_sql $dimensional where]

      </querytext>
</fullquery>

 
</queryset>
