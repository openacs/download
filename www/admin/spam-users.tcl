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
}

ad_require_permission [ad_conn package_id] "admin"
set user_id [ad_verify_and_get_user_id]

# ACS version passed sql_query as a query variable
# I've changed it to send only a list of signed user_ids
#  -- vinodk

db_multirow users user_select { *SQL* }

set user_id_list_export [export_vars -form -sign {user_id_list}]

ad_return_template
