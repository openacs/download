<?xml version="1.0"?>

<queryset>

<fullquery name="users_to_spam">
      <querytext>
      
    select distinct d.user_id
     from download_downloads_repository d
     where d.repository_id = :repository_id
           [ad_dimensional_sql $dimensional where]

      </querytext>
</fullquery>

</queryset>
