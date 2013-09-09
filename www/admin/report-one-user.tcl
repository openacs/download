# /packages/download/www/admin/report-one-user.tcl
ad_page_contract {
     
     @author jbank@arsdigita.com [jbank@arsdigita.com]
     @creation-date Thu Dec 14 16:11:49 2000
     @cvs-id $Id$
} {
    user_id:integer,notnull
    {orderby "archive_name"}
    {downloaded "1m"}
} -properties {
    first_names:onevalue
    last_name:onevalue
    context:onevalue
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
    {download_date "Download Date"
        {download_date}
        {}}
    {download_ip "From IP"
        {download_ip}
        {<td><a href=report-one-ip?[export_vars -url {download_ip downloaded}]>$download_ip</a> ($download_hostname)</td>}}
    {reason "Download Reason"
        {reason}
        {}}
}

db_1row name_select { *SQL* }

set dimensional_html [ad_dimensional $dimensional]
set table [ad_table \
        -Ttable_extra_html { width="90%" align="center" } \
        -bind [ad_tcl_vars_to_ns_set repository_id user_id] \
               download_table { *SQL* } $table_def ]

set context [list [list "report-by-user" "Downloads by User"] "$first_names $last_name"]
ad_return_template
