# /packages/download/www/admin/repository-reasons-edit.tcl
ad_page_contract {
     
     @author jbank@arsdigita.com [jbank@arsdigita.com]
     @creation-date Wed Jan 10 18:34:23 2001
     @cvs-id $Id$
} {
    download_reason_id:naturalnum,notnull
}

set repository_id [download_repository_id]
set user_id         [ad_conn user_id]

permission::require_permission -object_id $repository_id -privilege "admin"

form create edit_reason
element create edit_reason download_reason_id -label "Reason ID" -datatype integer -widget hidden
element create edit_reason reason -label "Reason" -datatype text -widget textarea -optional -html {rows 4 cols 40}


db_1row edit_info {select download_reason_id, reason from download_reasons where download_reason_id = :download_reason_id}
if { [form is_request edit_reason] } {
    element set_properties edit_reason download_reason_id -value $download_reason_id
    element set_properties edit_reason reason -value $reason
}

if {[form is_valid edit_reason]} {
    form get_values edit_reason
    db_dml edit_reason {
        update download_reasons set reason = :reason
        where download_reason_id = :download_reason_id
    }
    ad_returnredirect "repository-reasons"
    ad_script_abort
}

set title "Edit Reason"
set context [list [list "repository-types" "Repository Types"] $title]

ad_return_template
