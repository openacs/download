<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="download_table">
      <querytext>
      
    select u.last_name || ', ' || u.first_names as user_name,
           d.download_date,
           d.download_ip,
           nvl(d.download_hostname,'unavailable') as download_hostname,
           nvl(dar.version_name, 'unnamed') as version_name,
           dar.revision_id,
           u.user_id,
           u.email,
           nvl2(d.reason_id, d.reason, dr.reason) as reason
      from download_arch_revisions_obj dar, download_downloads d, download_reasons dr, cc_users u
     where d.user_id = u.user_id
       and dar.archive_id = $archive_id
       and dar.revision_id = d.revision_id
       and dr.download_reason_id(+) = d.reason_id
       [ad_dimensional_sql $dimensional where]
       [ad_order_by_from_sort_spec $orderby $table_def]

      </querytext>
</fullquery>

<partialquery name="version_clause">
      <querytext>

	dar.revision_id = content_item.get_live_revision(dar.archive_id)

      </querytext>
</partialquery>
 
<partialquery name="date_clause_1">
      <querytext>

	d.download_date + 1  > sysdate

      </querytext>
</partialquery>
 
<partialquery name="date_clause_7">
      <querytext>

	d.download_date + 7 > sysdate

      </querytext>
</partialquery>

<partialquery name="date_clause_30">
      <querytext>

	d.download_date + 30 > sysdate

      </querytext>
</partialquery>

</queryset>
