# /packages/download/www/admin/report-version-downloads.tcl
ad_page_contract {
     
     @author jbank@arsdigita.com [jbank@arsdigita.com]
     @creation-date Thu Dec 14 17:37:31 2000
     @cvs-id
} {
    {archive_id:integer,notnull}
    {orderby "last_name"}
    {downloaded 1m}
    {versions "current"}
}

ad_require_permission $archive_id "admin"

set dimensional {
   {versions "Versions" current {
       {current "current" {where "dar.revision_id = content_item.get_live_revision(dar.archive_id)" }}
       {all "all" ""}
   }}

    {downloaded "Download Period" 1m {
	{1d "last 24hrs" {where "d.download_date + 1 > SYSDATE"}}
        {1w "last week"  {where "d.download_date + 7 > SYSDATE"}}
        {1m "last month" {where "d.download_date + 30 > SYSDATE"}}
        {all "all" {}}
    }}
}

set table_def {
    {user_name "User Name"
    {user_name $order}
    {<td><a href=report-one-user?user_id=$user_id>$user_name</a></td>}}
    {version_name "Version"
    {version_name $order}
    {<td><a href=[ad_conn package_url]one-revision?[export_url_vars revision_id downloaded]>$version_name</a></td>}}
    {download_date "Download Date"
    {download_date $order}
    {}}
    {download_ip "From IP (hostname)"
    {download_ip $order}
    {<td><a href=report-one-ip?[export_url_vars download_ip downloaded]>$download_ip</a> ($download_hostname)</td>}}
    {reason "Download Reason"
    {reason $order}
    {<td>$reason</td>}}
}

db_1row name_select {
    select da.archive_name from download_archives_obj da where da.archive_id = :archive_id
}

if {$versions == "all" } {
    set version_str " in (
       select revision_id from download_arch_revisions_obj
        where archive_id = :archive_id )"
} else {
    set version_str " = (
       select revision_id from download_arch_revisions_obj
        where archive_id = :archive_id 
          and revision_id = content_item.get_live_revision(:archive_id))
       "
}

set count [db_string count_select "select count(*)
from   download_downloads d, download_arch_revisions_obj dar
where  dar.archive_id = :archive_id and
       d.revision_id = dar.revision_id 
       [ad_dimensional_sql $dimensional where]
"]

set temp_downloaded $downloaded

set total_count [db_string count_select "select count(*)
from   download_downloads d, download_arch_revisions_obj dar
where  dar.archive_id = :archive_id and 
       d.revision_id = dar.revision_id
       [ad_dimensional_sql $dimensional where]
"]
set downloaded $temp_downloaded 

set sql_query "
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
"

set export_sql_query [export_vars -url -sign {sql_query}]

set dimensional [ad_dimensional $dimensional]
set table [ad_table \
        -Ttable_extra_html { width= 90% align=center} \
        -bind [ad_tcl_vars_to_ns_set archive_id] \
        download_table $sql_query $table_def ]

set context_bar [list "$archive_name Download History"]

ad_return_template
