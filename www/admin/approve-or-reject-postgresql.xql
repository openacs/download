<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="revision_info_select">      
      <querytext>
      
select da.repository_id as repository_id,
       da.archive_name,
       da.summary,
       dar.revision_id,
       dar.file_name,
       dar.version_name,
       dar.file_size / 1024 as file_size,
       case when da.latest_revision = dar.revision_id then 't' else 'f' end as current_version_p,
       dar.creation_user,
       dar.creation_date,
       u.last_name || ', ' || u.first_names as creation_user_name
from   download_archives_obj da,
       download_arch_revisions_obj dar,
       cc_users u
where  da.archive_id = dar.archive_id and
       dar.revision_id = :revision_id and
       u.user_id = dar.creation_user

      </querytext>
</fullquery>

 
</queryset>
