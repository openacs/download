<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="my_revisions">      
      <querytext>
      
        select da.archive_name,
               dar.version_name,
               dar.revision_id,
               dar.approved_p,
               nvl(dar.approved_comment, 'No comment') approved_comment,
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
       dbms_lob.getlength(dar.content) as file_size,       
       (select count(*) from download_downloads where revision_id = dar.revision_id) as downloads,
       dar.approved_p 
       $metadata_selects
from   download_archives_obj da,
       download_archive_types dat,
       download_arch_revisions_obj dar
where  da.repository_id = :repository_id and
       dat.archive_type_id = da.archive_type_id and
       da.archive_id = dar.archive_id and
       acs_permission.permission_p(dar.revision_id, :user_id, 'read') = 't'
       $approval
       [ad_dimensional_sql $dimensional where]
       [ad_order_by_from_sort_spec $orderby $table_def]
      </querytext>
</fullquery>
 
<partialquery name="archive_where_clause">      
      <querytext>
      
   dar.revision_id = content_item.get_live_revision(da.archive_id)

      </querytext>
</partialquery>

<partialquery name="date_clause">      
      <querytext>

   sysdate

      </querytext>
</partialquery>

</queryset>
