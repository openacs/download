# /packages/download/www/admin/all-user-downloads.tcl
ad_page_contract {
     
     @author jbank@arsdigita.com [jbank@arsdigita.com]
     @creation-date Wed Dec 13 13:39:29 2000
     @cvs-id
} {
    {downloaded "1m"}
}

set repository_id [download_repository_id]
##TODO: Add support for other

# vinodk: put in the full query name so that when I
#         pass this var to spam-users, it can find
#         the right query
set dimensional {
    {downloaded "Download Period" 1m {
        {1d "last 24hrs" {where "[db_map dbqd.download.www.admin.report-by-user.date_clause_1]"}}
        {1w "last week"  {where "[db_map dbqd.download.www.admin.report-by-user.date_clause_7]"}}
        {1m "last month" {where "[db_map dbqd.download.www.admin.report-by-user.date_clause_30]"}}
        {all "all" {}}}}
}

set table_def {
    {user_name "User Name (Last name, first name)"
               {no_sort}
               {<td><a href=report-one-user?[export_url_vars user_id downloaded]>$user_name</a> (<a href=mailto:$email>$email</a>)</td>}}
    {num_downloads "# Downloads" {no_sort} {}}
}

set sql_query "
    select min(u.last_name || ', ' || u.first_names) as user_name,
           min(u.email) as email,
           d.user_id,
           count(*) as num_downloads,
           min('$downloaded') as downloaded
     from download_downloads_repository d, cc_users u
     where d.repository_id = $repository_id and
           d.user_id = u.user_id
           [ad_dimensional_sql $dimensional where]
     group by d.user_id
     order by 2 desc
"

set export_sql_query [export_vars -url -sign {downloaded repository_id dimensional}]

set dimensional_html [ad_dimensional $dimensional]
set table [ad_table \
        -Ttable_extra_html { width= 90% align=center} \
        -bind [ad_tcl_vars_to_ns_set repository_id downloaded] \
        download_table $sql_query $table_def ]

set context [list "Downloads by User"]
ad_return_template