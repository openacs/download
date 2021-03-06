<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="download_table">
      <querytext>
      
    select d.user_id,
           min(u.last_name || ', ' || u.first_names) as user_name,
           min(u.email) as email,
           count(*) as num_downloads
     from download_downloads_repository d, cc_users u
     where d.repository_id = :repository_id and
           d.user_id = u.user_id
           [ad_dimensional_sql $dimensional where]
     group by d.user_id
     order by 2

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
