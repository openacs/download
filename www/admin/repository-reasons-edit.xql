<?xml version="1.0"?>
<queryset>

<fullquery name="edit_info">      
      <querytext>
      select download_reason_id, reason from download_reasons where download_reason_id = :download_reason_id
      </querytext>
</fullquery>

 
<fullquery name="edit_reason">      
      <querytext>
      
        update download_reasons set reason = :reason
        where download_reason_id = :download_reason_id
    
      </querytext>
</fullquery>

 
</queryset>
