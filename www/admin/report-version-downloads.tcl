# /packages/download/www/admin/report-version-downloads.tcl
ad_page_contract {
     
     @author jbank@arsdigita.com [jbank@arsdigita.com]
     @creation-date Thu Dec 14 17:37:31 2000
     @cvs-id $Id$
} {
    {archive_id:integer,notnull}
    {orderby "last_name"}
    {downloaded 1m}
    {versions "current"}
} -properties {
    archive_name:onevalue
    context:onevalue
    user_id_list_export:onevalue
    dimensional_html:onevalue
    current_count:onevalue
    total_count:onevalue
    table:onevalue
}

set repository_id [download_repository_id]

permission::require_permission -object_id $archive_id -privilege "admin"

set dimensional {
   {versions "Versions" current {
       {current "current" {where "[db_map version_clause]" }}
       {all "all" ""}
   }}

    {downloaded "Download Period" 1m {
		{1d "last 24hrs" {where "[db_map date_clause_1]"}}
        {1w "last week"  {where "[db_map date_clause_7]"}}
        {1m "last month" {where "[db_map date_clause_30]"}}
        {all "all" {}}
    }}
}

set table_def {
    {user_name "User Name"
        {user_name $order}
        {<td><a href="report-one-user?user_id=$user_id">$user_name</a></td>}}
    {version_name "Version"
        {version_name $order}
        {<td><a href="[ad_conn package_url]one-revision?[export_vars -url {revision_id downloaded}]">$version_name</a></td>}}
    {download_date "Download Date"
        {download_date $order}
        {}}
    {download_ip "From IP (hostname)"
        {download_ip $order}
        {<td><a href="report-one-ip?[export_vars -url {download_ip downloaded}]">$download_ip</a> ($download_hostname)</td>}}
    {reason "Download Reason"
        {reason $order}
        {<td>$reason</td>}}
}

db_1row name_select { *SQL* }

set current_count [db_string current_count { *SQL* }]
set total_count [db_string total_count { *SQL* }]

set dimensional_html [ad_dimensional $dimensional]
set table [ad_table \
        -Ttable_extra_html { width="90%" align="center" } \
        -bind [ad_tcl_vars_to_ns_set archive_id] \
               download_table { *SQL* } $table_def ]

# query users to spam
set user_id_list [db_list users_to_spam { *SQL* }]
set user_id_list_export [export_vars -form -sign user_id_list]

set context [list "$archive_name Download History"]

ad_return_template
