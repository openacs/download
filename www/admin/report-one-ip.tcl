# /packages/download/www/admin/report-one-ip.tcl
ad_page_contract {
    Show all downloaders from a single IP address
     
     @author jbank@arsdigita.com [jbank@arsdigita.com]
     @creation-date Thu Dec 14 16:11:49 2000
     @cvs-id $Id$
} {
    download_ip:notnull
    {orderby "archive_name"}
    {downloaded "1m"}
} -properties {
    download_ip:onevalue
    context:onevalue
    user_id_list_export:onevalue
    dimensional_html:onevalue
    table:onevalue
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
    {<td><a href="report-one-user?[export_vars -url {user_id downloaded}]">$user_name</a></td>}}
    {download_date "Download Date"
    {download_date}
    {}}
    {reason "Download Reason"
    {reason}
    {}}
}

set dimensional_html [ad_dimensional $dimensional]
set table [ad_table \
        -Ttable_extra_html { width="90%" align="center" } \
        -bind [ad_tcl_vars_to_ns_set repository_id download_ip] \
               download_table { *SQL* } $table_def ]

# query users to spam
set user_id_list [db_list users_to_spam { *SQL* }]
set user_id_list_export [export_vars -form -sign user_id_list]

set context [list [list "report-by-ip" "Downloads by IP"] "$download_ip"]

ad_return_template
