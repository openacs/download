# /packages/download/www/admin/report-by-ip.tcl
ad_page_contract {
    List of IP addresses that have downloaded a specific archive
     
     @author jbank@arsdigita.com [jbank@arsdigita.com]
     @creation-date Wed Dec 13 13:39:29 2000
     @cvs-id $Id$
} {
    {downloaded "1m"}
} -properties {
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
        {all "all" {}}}}
}

set table_def {
    {download_ip "From IP"
               {no_sort}
               {<td><a href="report-one-ip?[export_url_vars download_ip downloaded]">$download_ip</a></td>}}
    {download_hostname "Hostname" {} {}}
    {num_downloads "# Downloads" {no_sort} {}}
}

set dimensional_html [ad_dimensional $dimensional]
set table [ad_table \
        -Ttable_extra_html { width="90%" align="center" } \
        -bind [ad_tcl_vars_to_ns_set repository_id downloaded] \
               download_table { *SQL* } $table_def ]

# query users to spam
set user_id_list [db_list users_to_spam { *SQL* }]
set user_id_list_export [export_vars -form -sign user_id_list]

set context [list "Downloads by IP"]

ad_return_template