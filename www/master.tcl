# /packages/download/www/master.tcl
ad_page_contract {
     Code to setup the master template
     @author jbank@arsdigita.com [jbank@arsdigita.com]
     @creation-date Fri Dec 15 15:20:12 2000
     @cvs-id
} {
}

set master_header [ad_header [ad_decode [value_if_exists title] "" "" [value_if_exists title]] ]
set master_title  [value_if_exists title]
set master_context_bar [eval ad_context_bar [value_if_exists context_bar]]
set master_footer [ad_footer]

set master_admin_p [ad_permission_p [ad_conn package_id] admin]
