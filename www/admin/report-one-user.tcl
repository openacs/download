# /packages/download/www/admin/report-one-user.tcl
ad_page_contract {
     
     @author jbank@arsdigita.com [jbank@arsdigita.com]
     @creation-date Thu Dec 14 16:11:49 2000
     @cvs-id $Id$
} {
    user_id:naturalnum,notnull
    {orderby:token "archive_name"}
    {downloaded "1m"}
} -properties {
    first_names:onevalue
    last_name:onevalue
    context:onevalue
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
    -html { width "90%" align "center"} \
    -elements {
        archive_name {
            label "Archive"
            link_url_col url_archive_id 
            orderby archive_name
        }
        version_name {
            label "Version"
            link_url_col url_archive_id
            orderby version_name
        }
        download_date {
            label "Download Date"
	    orderby download_date
        }
        download_ip {
            label "From IP"
            display_template {
                <a href="@history.url_one_ip@">@history.download_ip@</a> (@history.download_hostname@)
            }
	    orderby download_ip
        }
        reason {
            label "Download Reason"
	    orderby reason
        }
    } -filters {user_id {} downloaded {}}

db_1row name_select { *SQL* }

set dimensional_html [ad_dimensional $dimensional]

db_multirow -extend {url_one_ip url_archive_id} history download_table { *SQL* } {
    set url_archive_id [export_vars -base "../one-revision" {revision_id}]
    set url_one_ip [export_vars -base "report-one-ip" {download_ip downloaded}]
}


set context [list [list "report-by-user" "Downloads by User"] "$first_names $last_name"]
ad_return_template
