# /packages/download/www/admin/report-one-ip.tcl
ad_page_contract {
    Show all downloaders from a single IP address
     
     @author jbank@arsdigita.com [jbank@arsdigita.com]
     @creation-date Thu Dec 14 16:11:49 2000
     @cvs-id $Id$
} {
    download_ip:notnull
    {orderby:token "archive_name"}
    {downloaded "1m"}
} -properties {
    download_ip:onevalue
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
        {all "all" {}}}
	}
}

template::list::create -name history_list \
    -multirow history \
    -html {width "90%" align center} \
    -elements {
        archive_name {
            label "Archive"
            link_url_col url_archive
            orderby archive_name
        } 
        version_name {
            label "Version"
            link_url_col url_archive
            orderby version_name
        }
        user_name {
            label "User Name"
            link_url_col url_one_user
            orderby user_name
        } 
        download_date {
            label "Download Date"
            orderby download_date
        } 
        reason {
            label "Download Reason"
            orderby reason
        }
    } -filters {download_ip {} downloaded {}}

set dimensional_html [ad_dimensional $dimensional]

db_multirow -extend {url_one_user url_archive} history download_table { *SQL* } {
    set url_archive [export_vars -base "../one-revision" {archive_id}]
    set url_one_user [export_vars -base "report-one-user" {user_id downloaded}]
}

# query users to spam
set user_id_list [db_list users_to_spam { *SQL* }]
set user_id_list_export [export_vars -form -sign user_id_list]

set context [list [list "report-by-ip" "Downloads by IP"] "$download_ip"]

ad_return_template
