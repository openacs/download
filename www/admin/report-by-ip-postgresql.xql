<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="download_table">
      <querytext>
      
    select min(u.last_name || ', ' || u.first_names) as user_name,
           min(u.email) as email,
           min(d.user_id) as user_id,
           d.download_ip,
           coalesce(min(d.download_hostname),'unavailable') as download_hostname,
           count(*) as num_downloads,
           min('$downloaded'::varchar) as downloaded
     from download_downloads_repository d, cc_users u
     where d.repository_id = $repository_id and
           d.user_id = u.user_id
           [ad_dimensional_sql $dimensional where]
     group by d.download_ip
     order by 2 desc

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
