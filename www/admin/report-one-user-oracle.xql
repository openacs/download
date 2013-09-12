<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="download_table">
      <querytext>

    select da.repository_id,
           da.archive_name, 
           da.archive_id, 
           dar.revision_id,
           dar.version_name,
           d.download_date,
           d.download_ip,
           nvl(d.download_hostname,'unavailable') as download_hostname,
           nvl2(d.reason_id, dr.reason, d.reason) as reason
      from download_archives_obj da, download_arch_revisions_obj dar, download_downloads d, download_reasons dr
     where da.repository_id = :repository_id
       and da.archive_id = dar.archive_id
       and d.revision_id = dar.revision_id
       and d.user_id = :user_id
       and dr.download_reason_id(+) = d.reason_id
       [ad_dimensional_sql $dimensional where]
       [template::list::orderby_clause -orderby -name history_list]
      
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
