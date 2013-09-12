<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="download_table">
<querytext>
      
select u.user_id,
       u.email,
       u.last_name || ', ' || u.first_names as user_name,
       d.download_date,
       d.download_ip,
       coalesce(d.download_hostname,'unavailable') as download_hostname,
       coalesce(dar.version_name, 'unnamed') as version_name,
       dar.revision_id,
       case when d.reason_id is null then d.reason else dr.reason end as reason
from download_downloads d left join download_reasons dr
  on (d.reason_id=dr.download_reason_id),
     download_arch_revisions_obj dar, 
     cc_users u
where d.user_id = u.user_id
      and dar.archive_id = :archive_id
      and dar.revision_id = d.revision_id
      [ad_dimensional_sql $dimensional where]
      [template::list::orderby_clause -orderby -name download_list]

</querytext>
</fullquery>


<partialquery name="version_clause">
<querytext>

dar.revision_id = content_item__get_live_revision(dar.archive_id)

</querytext>
</partialquery>

 

<partialquery name="date_clause_1">
<querytext>

d.download_date + '1 days'::interval > current_timestamp

</querytext>
</partialquery>

 

<partialquery name="date_clause_7">
<querytext>

d.download_date + '7 days'::interval > current_timestamp

</querytext>
</partialquery>



<partialquery name="date_clause_30">
<querytext>

d.download_date + '30 days'::interval > current_timestamp

</querytext>
</partialquery>



</queryset>

