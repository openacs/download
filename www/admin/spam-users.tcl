# /packages/download/www/admin/spam-users.tcl
ad_page_contract {
    Spam downloaders based on the user_id list passed in. The user_id list 
    must be signed.

     @author jbank@arsdigita.com [jbank@arsdigita.com]
     @creation-date Mon Jan  8 17:33:15 2001
     @cvs-id $Id$
} {
    user_id_list:verify
} -properties {
    users:multirow
    user_id_list_export:onevalue
    no_spam_count:onevalue
}

ad_require_permission [ad_conn package_id] "admin"
set user_id [ad_verify_and_get_user_id]

# get name, email and
# remove any users who don't want spam

set want_spam_list {}
db_multirow users user_select { *SQL* } {
    lappend want_spam_list $user_id
}
set no_spam_count [expr [llength user_id_list] - [llength want_spam_list]]
set user_id_list $want_spam_list

set user_id_list_export [export_vars -form -sign {user_id_list}]

ad_return_template
