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

 
</queryset>
