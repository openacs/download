<?xml version="1.0"?>
<queryset>

<fullquery name="creation_email_select">      
      <querytext>
      
        select da.archive_name,
               dar.creation_user,
               dar.version_name
          from download_arch_revisions_obj dar, download_archives_obj da
         where da.archive_id = dar.archive_id and dar.revision_id = :revision_id
    
      </querytext>
</fullquery>

 
<fullquery name="approving_user_select">      
      <querytext>
      
        select email as approving_email,
               first_names || ' ' || last_name as approving_name
          from cc_users 
         where user_id = :user_id
    
      </querytext>
</fullquery>

 
</queryset>
