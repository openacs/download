# /packages/download/www/admin/report-one-ip-.tcl
ad_page_contract {
     
     @author jbank@arsdigita.com [jbank@arsdigita.com]
     @creation-date Thu Dec 14 16:11:49 2000
     @cvs-id $Id$
} {
    download_ip:notnull
    {orderby "archive_name"}
    {downloaded "1m"}
}


set repository_id [download_repository_id]
set dimensional {
    {downloaded "Download Period" 1m {
        {1d "last 24hrs" {where "[db_map date_clause_1]"}}
        {1w "last week"  {where "[db_map date_clause_7]"}}
        {1m "last month" {where "[db_map date_clause_30]"}}
        {all "all" {}}}
	}
}


set table_def {
    {archive_name "Archive"
    {archive_name $order}
    {<td><a href="../one-archive?archive_id=$archive_id">$archive_name</a></td>}}
    {version_name "Version"
    {version_name $order}
    {<td><a href="../one-revision?revision_id=$revision_id">$version_name</a></td>}}
    {user_name "User Name"
    {user_name}
    {<td><a href="report-one-user?[export_url_vars user_id downloaded]">$user_name</a></td>}}
    {download_date "Download Date"
    {download_date}
    {}}
    {reason "Download Reason"
    {reason}
    {}}
}

set sql_query "
    select da.archive_name, 
           da.archive_id, 
           dar.revision_id,
           dar.version_name,
           d.download_date,
           u.last_name || ', ' || u.first_names as user_name,
           u.user_id,
           u.email,
           nvl(d.download_hostname,'unavailable') as download_hostname,
           nvl2(d.reason_id, d.reason, dr.reason) as reason
      from download_archives_obj da, download_arch_revisions_obj dar, download_downloads d, download_reasons dr, cc_users u
     where da.repository_id = $repository_id
       and da.archive_id = dar.archive_id
       and d.revision_id = dar.revision_id
       and d.download_ip = '$download_ip'
       and dr.download_reason_id(+) = d.reason_id
       and u.user_id = d.user_id
       [ad_dimensional_sql $dimensional where]
       [ad_order_by_from_sort_spec $orderby $table_def]
"

set export_sql_query [export_vars -url -sign {downloaded repository_id dimensional}]

set dimensional_html [ad_dimensional $dimensional]
set table [ad_table \
        -Ttable_extra_html { width= 90% align=center} \
        -bind [ad_tcl_vars_to_ns_set repository_id download_ip] \
        download_table $sql_query $table_def ]

set context [list [list "report-by-ip" "Downloads by IP"] "$download_ip"]

ad_return_template
