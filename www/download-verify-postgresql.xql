<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="revision_info_select">      
      <querytext>
      
select da.archive_id,
       da.repository_id as repository_id,
       da.archive_name,
       da.summary,
       dar.revision_id,
       dar.file_name,
       dar.version_name,
       dar.content as content_path
from   download_archives_obj da,
       download_arch_revisions_obj dar
where  da.archive_id = dar.archive_id and
       dar.revision_id = :revision_id 
       $approval

      </querytext>
</fullquery>

 
</queryset>
