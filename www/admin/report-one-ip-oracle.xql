<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="download_table">
      <querytext>

    select u.user_id,
           u.last_name || ', ' || u.first_names as user_name,
           u.email,
           da.archive_name, 
           da.archive_id, 
           dar.revision_id,
           dar.version_name,
           d.download_date,
           nvl(d.download_hostname,'unavailable') as download_hostname,
           nvl2(d.reason_id, dr.reason, d.reason) as reason
      from download_archives_obj da, download_arch_revisions_obj dar, download_downloads d, download_reasons dr, cc_users u
     where da.repository_id = $repository_id
       and da.archive_id = dar.archive_id
       and d.revision_id = dar.revision_id
       and d.download_ip = '$download_ip'
       and dr.download_reason_id(+) = d.reason_id
       and u.user_id = d.user_id
       [ad_dimensional_sql $dimensional where]
       [ad_order_by_from_sort_spec $orderby $table_def]
      
      </querytext>
</fullquery>

<partialquery name="date_clause_1">
      <querytext>

	d.download_date + 1 > SYSDATE

      </querytext>
</partialquery>
 
<partialquery name="date_clause_7">
      <querytext>

	d.download_date + 7 > SYSDATE

      </querytext>
</partialquery>

<partialquery name="date_clause_30">
      <querytext>

	d.download_date + 30 > SYSDATE

      </querytext>
</partialquery>

</queryset>
