<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="download_table">
      <querytext>

    select da.repository_id,
           da.archive_name, 
           da.archive_id, 
           dar.revision_id,
           dar.version_name,
           d.download_date,
           d.download_ip,
           coalesce(d.download_hostname,'unavailable') as download_hostname,
           case when d.reason_id is null then d.reason else dr.reason end as reason
      from download_downloads d left join download_reasons dr 
			on (d.reason_id = dr.download_reason_id),
		   download_archives_obj da, 
           download_arch_revisions_obj dar 
     where da.repository_id = :repository_id
       and da.archive_id = dar.archive_id
       and d.revision_id = dar.revision_id
       and d.user_id = $user_id
       [ad_dimensional_sql $dimensional where]
       [ad_order_by_from_sort_spec $orderby $table_def]

      </querytext>
</fullquery>

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
