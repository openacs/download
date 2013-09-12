<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

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
           coalesce(d.download_hostname,'unavailable') as download_hostname,
           case when d.reason_id is null then d.reason else dr.reason end as reason
      from download_downloads d left join download_reasons dr 
			on (d.reason_id=dr.download_reason_id),
		   download_archives_obj da, 
		   download_arch_revisions_obj dar, 
		   cc_users u
     where da.repository_id = :repository_id
       and da.archive_id = dar.archive_id
       and d.revision_id = dar.revision_id
       and d.download_ip = :download_ip
       and u.user_id = d.user_id
       [ad_dimensional_sql $dimensional where]
       [template::list::orderby_clause -orderby -name history_list]

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
