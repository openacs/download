<?xml version="1.0"?>
<queryset>

<fullquery name="repository_info">      
      <querytext>
      
    select title, description, help_text from download_repository_obj where repository_id = :repository_id

      </querytext>
</fullquery>

 
<fullquery name="rep_count_get">      
      <querytext>
      select count(*) from download_repository_obj where repository_id = :repository_id
      </querytext>
</fullquery>

 
</queryset>
