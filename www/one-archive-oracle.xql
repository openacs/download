<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="archive_info_select">      
      <querytext>
      
   select da.archive_name, 
          da.summary,
          da.description, 
          da.description_type, 
          u.last_name || ', ' || u.first_names as creation_user_name,
          da.creation_user, 
          to_char(da.creation_date,'Mon DD, YYYY') as creation_date
     from download_archives_obj da, cc_users u
    where da.archive_id = :archive_id
      and u.user_id = da.creation_user

      </querytext>
</fullquery>

 
<fullquery name="rep_get_revisions">      
      <querytext>
      
    select dar.file_name,
           dar.version_name,
           dar.revision_id,
           u.last_name || ', ' || u.first_names as creation_user_name,
           dar.creation_user, 
           to_char(dar.creation_date,'Mon DD, YYYY') as creation_date
           
    from download_arch_revisions_obj dar, cc_users u
    where dar.archive_id = :archive_id
          and approved_p = 't' and
          u.user_id = dar.creation_user
    order by version_name

      </querytext>
</fullquery>

 
</queryset>
