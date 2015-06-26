# /packages/download/www/admin/report-version-downloads.tcl
ad_page_contract {
     
     @author jbank@arsdigita.com [jbank@arsdigita.com]
     @creation-date Thu Dec 14 17:37:31 2000
     @cvs-id $Id$
} {
    {archive_id:naturalnum,notnull}
    {orderby:token "user_name"}
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

template::list::create -name download_list \
    -multirow downloads \
    -html {width "90%" align center} \
    -elements {
        user_name { 
            label "User Name"
            orderby user_name
            link_url_col url_one_user
        }
        version_name {
            label "Version"
            orderby version_name
            link_url_col url_one_revision
            
        } 
        download_date {
            label "Download Date"
            orderby download_date
        }
        download_ip {
            label "From IP (hostname)"
            orderby download_ip
            display_template {
                <a href="@downloads.url_one_ip@">@downloads.download_ip@</a> (@downloads.download_hostname@)
            }
        }
        reason {
            label "Download Reason"
            orderby reason
        }
    } -filters {archive_id {} downloaded {} versions {}}

db_1row name_select { *SQL* }

set current_count [db_string current_count { *SQL* }]
set total_count [db_string total_count { *SQL* }]

set dimensional_html [ad_dimensional $dimensional]

set pkg_url [ad_conn package_url]
db_multirow -extend {url_one_ip url_one_revision url_one_user} downloads download_table { *SQL* } {
    set url_one_user [export_vars -base report-one-user {user_id}]
    set url_one_revision [export_vars -base "${pkg_url}one-revision" {revision_id downloaded}]
    set url_one_ip [export_vars -base report-one-ip {download_ip downloaded}]
}

# query users to spam
set user_id_list [db_list users_to_spam { *SQL* }]
set user_id_list_export [export_vars -form -sign user_id_list]

set context [list "$archive_name Download History"]

ad_return_template
