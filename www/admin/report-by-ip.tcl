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

set repository_id [download::repository_id]

set dimensional {
    {downloaded "Download Period" 1m {
        {1d "last 24hrs" {where "[db_map date_clause_1]"}}
        {1w "last week"  {where "[db_map date_clause_7]"}}
        {1m "last month" {where "[db_map date_clause_30]"}}
        {all "all" {}}}}
}

template::list::create -name ips_list \
    -multirow ips \
    -html {width "90%" style "margin: 0 auto;"} \
    -elements {
        download_ip {
            label "From IP"
            link_url_col one_ip_url
        }
        download_hostname {
            label "Hostname"
        }
        num_downloads {
            label "# Downloads"
        }
    }

set dimensional_html [ad_dimensional $dimensional]

db_multirow -extend {one_ip_url} ips download_table { *SQL* } {
    set one_ip_url [export_vars -base report-one-ip {download_ip downloaded}]
}

# query users to spam
set user_id_list [db_list users_to_spam { *SQL* }]
set user_id_list_export [export_vars -form -sign user_id_list]

set context [list "Downloads by IP"]

ad_return_template
