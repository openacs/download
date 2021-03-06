<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="revision_info_select">      
      <querytext>
               
select da.archive_id,
       dat.pretty_name as archive_type,
       da.archive_type_id,
       da.archive_name,
       da.summary,
       da.description,
       da.description_type,
       dar.revision_id,
       dar.file_name,
       dar.version_name,
       dar.version_name,
       round(dbms_lob.getlength(dar.content) / 1024) as file_size,       
       (select count(*) from download_downloads where revision_id = dar.revision_id) as downloads,
       dar.approved_p,
       u.last_name || ', ' || u.first_names as creation_user_name,
       dar.creation_user, 
       dar.creation_date 
       $metadata_selects
from   download_archives_obj da,
       download_archive_types dat,
       download_arch_revisions_obj dar,
       cc_users u
where  da.repository_id = :repository_id and
       dat.archive_type_id = da.archive_type_id and
       da.archive_id = dar.archive_id and
       dar.revision_id = :revision_id and
       dar.creation_user = u.user_id

      </querytext>
</fullquery>

 
</queryset>
