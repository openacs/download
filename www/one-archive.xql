<?xml version="1.0"?>
<queryset>

<fullquery name="pending_count_select">      
      <querytext>
      
        select count(*)
          from download_arch_revisions_obj dar
         where dar.archive_id = :archive_id
           and approved_p is null
    
      </querytext>
</fullquery>

 
</queryset>
