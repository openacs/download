<?xml version="1.0"?>
<queryset>

<fullquery name="name_select">      
      <querytext>
      
    select da.archive_name from download_archives_obj da where da.archive_id = :archive_id

      </querytext>
</fullquery>

 
<fullquery name="current_count">      
      <querytext>
      select count(*)
from   download_downloads d, download_arch_revisions_obj dar
where  dar.archive_id = :archive_id and
       d.revision_id = dar.revision_id
       [ad_dimensional_sql $dimensional where]

      </querytext>
</fullquery>

<fullquery name="total_count">      
      <querytext>
      select count(*)
from   download_downloads d, download_arch_revisions_obj dar
where  dar.archive_id = :archive_id and
       d.revision_id = dar.revision_id 

      </querytext>
</fullquery>

 
<fullquery name="users_to_spam">
      <querytext>
      
select distinct d.user_id
from download_downloads_repository d,
     download_arch_revisions_obj dar
where d.repository_id = :repository_id
      and dar.archive_id = :archive_id
      and dar.revision_id = d.revision_id
      [ad_dimensional_sql $dimensional where]

      </querytext>
</fullquery>


</queryset>
