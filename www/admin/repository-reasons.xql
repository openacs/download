<?xml version="1.0"?>
<queryset>

<fullquery name="repository_reasons_insert">      
      <querytext>
      
        insert into download_reasons (download_reason_id, repository_id, reason) values (:download_reason_id, :repository_id, :reason)
    
      </querytext>
</fullquery>

 
<fullquery name="reasons_select">      
      <querytext>
      
    select download_reason_id, reason from download_reasons where repository_id = :repository_id

      </querytext>
</fullquery>

 
</queryset>
