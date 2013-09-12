<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="my_revisions">      
      <querytext>
      
        select da.archive_name,
               dar.version_name,
               dar.revision_id,
               dar.approved_p,
               coalesce(dar.approved_comment, 'No comment') as approved_comment,
               to_char(dar.creation_date,'Mon DD, YYYY') as creation_date
    from download_arch_revisions_obj dar, download_archives_obj da
    where da.repository_id = :repository_id and
          dar.archive_id = da.archive_id and
          approved_p != 't' and
          dar.creation_user = :user_id
    order by creation_date

      </querytext>
</fullquery>

<fullquery name="download_index_query">      
      <querytext>
select da.archive_id,
       dat.pretty_name as archive_type,
       da.archive_type_id,
       da.archive_name,
       da.summary,
       dar.revision_id,
       dar.file_name,
       dar.version_name,
       dar.file_size / 1024 as file_size,       
       (select count(*) from download_downloads where revision_id = dar.revision_id) as downloads,
       dar.approved_p 
       $metadata_selects
from   download_archives_obj da,
       download_archive_types dat,
       download_arch_revisions_obj dar
where  da.repository_id = :repository_id and
       dat.archive_type_id = da.archive_type_id and
       da.archive_id = dar.archive_id and
       acs_permission__permission_p(dar.revision_id, :user_id, 'read') = 't'
       $approval
       [ad_dimensional_sql $dimensional where]
       [template::list::orderby_clause -orderby -name download_list]
      </querytext>
</fullquery>

<partialquery name="archive_where_clause">      
      <querytext>
      
   dar.revision_id = content_item__get_live_revision(da.archive_id)

      </querytext>
</partialquery>

<partialquery name="date_clause_1">
      <querytext>

	dar.publish_date + '1 days'::interval > current_timestamp

      </querytext>
</partialquery>
 
<partialquery name="date_clause_7">
      <querytext>

	dar.publish_date + '7 days'::interval > current_timestamp

      </querytext>
</partialquery>

<partialquery name="date_clause_30">
      <querytext>

	dar.publish_date + '30 days'::interval > current_timestamp

      </querytext>
</partialquery>

</queryset>
