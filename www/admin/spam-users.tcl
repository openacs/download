# /packages/download/www/admin/spam-users.tcl
ad_page_contract {
     Spam downloaders based on the queyr passed in
     @author jbank@arsdigita.com [jbank@arsdigita.com]
     @creation-date Mon Jan  8 17:33:15 2001
     @cvs-id $Id$
} {
	downloaded:verify
	repository_id:verify
	dimensional:verify
}

ad_require_permission [ad_conn package_id] "admin"
set user_id [ad_verify_and_get_user_id]

# ACS version passed sql_query as a query variable
#  I changed it to pass the important parameters
#   and then build the query by grabbing the 
#   appropriate query using the query dispatcher
#  -- vinodk

set sql_query [subst [db_fullquery_get_querytext [db_qd_fetch dbqd.download.www.admin.report-by-user.download_table]]]

ns_log notice "vinodk: $sql_query"
ns_log notice "vinodk: $dimensional"

set userlist_str ""
set email_list [list]
set old_userid 0
set count 0

#TODO: Add where clause that checks from no_spam pref.
db_foreach user_select "select u.email, u.user_id, u.user_name from ($sql_query) u" {
    if { $user_id != $old_userid } {
		append userlist_str "<li>$user_name (<a href=mailto:$email>$email</a>)"
		lappend userid_list $user_id
    }
    set old_userid $user_id
    incr count
}

# Display user name only when count is less than 25
if { $count > 25 } {
    set userlist_str "<li>$count users will receive your spam."
}

set userid_list_export [export_vars -form -sign {userid_list}]

ad_return_template
