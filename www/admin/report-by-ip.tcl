# /packages/download/www/admin/report-by-ip.tcl
ad_page_contract {
    List of IP addresses that have downloaded a specific archive
     
     @author jbank@arsdigita.com [jbank@arsdigita.com]
     @creation-date Wed Dec 13 13:39:29 2000
     @cvs-id $Id$
} {
    {downloaded "1m"}
}

set repository_id [download_repository_id]
##TODO: Add support for other

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

set sql_query "
    select min(d.user_id) as user_id,
           min(u.last_name || ', ' || u.first_names) as user_name,
           min(u.email) as email,
           d.download_ip,
           nvl(min(d.download_hostname),'unavailable') as download_hostname,
           count(*) as num_downloads,
           min('$downloaded') as downloaded
     from download_downloads_repository d, cc_users u
     where d.repository_id = $repository_id and
           d.user_id = u.user_id
           [ad_dimensional_sql $dimensional where]
     group by d.download_ip
     order by 2 desc
"

set dimensional_html [ad_dimensional $dimensional]
set table [ad_table \
        -Ttable_extra_html { width= 90% align=center} \
        -bind [ad_tcl_vars_to_ns_set repository_id downloaded] \
        download_table $sql_query $table_def ]

# vinodk: the download_table query gets the list of users (plus other data)
#         we reuse the same query to get the list of user_id's to spam.
#         Since we're using db_list, it's important that the first column 
#         of the query is the user_id.

set user_id_list [db_list download_table { *SQL* }]
set user_id_list_export [export_vars -url -sign user_id_list]

set context [list "Downloads by IP"]

ad_return_template