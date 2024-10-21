# /packages/download/www/admin/report-by-user.tcl
ad_page_contract {
     Show list of users who have downloaded a specified archive.

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

set repository_id [download::repository_id]

set dimensional {
    {downloaded "Download Period" 1m {
        {1d "last 24hrs" {where "[db_map date_clause_1]"}}
        {1w "last week"  {where "[db_map date_clause_7]"}}
        {1m "last month" {where "[db_map date_clause_30]"}}
        {all "all" {}}}}
}

set dimensional_html [ad_dimensional $dimensional]

template::list::create -name users_list \
    -multirow users \
    -html { width "90%" style "margin: 0 auto;"} \
    -elements {
        user_name {
            label "User Name (Last name, first name)"
            display_template {
                <a href="@users.report_one_url@">@users.user_name@</a> 
                (<a href="mailto:@users.email@">@users.email@</a>)
            }
        }
        num_downloads {
            label "# Downloads"
        }
    }

db_multirow -extend {report_one_url} users download_table { *SQL* } {
    set report_one_url "[export_vars -base report-one-user {user_id downloaded}]"
}

# query users to spam
set user_id_list [db_list users_to_spam { *SQL* }]
set user_id_list_export [export_vars -form -sign user_id_list]

set context [list "Downloads by User"]
ad_return_template
