# /packages/download/www/admin/repository-reasons.tcl
ad_page_contract {
     Repository reasons
     @author jbank@arsdigita.com [jbank@arsdigita.com]
     @creation-date Tue Dec 12 15:58:00 2000
     @cvs-id
} {
}

set repository_id [download_repository_id]
ad_require_permission $repository_id "admin"

set title "Download Repository Download Reasons"
set context_bar [list "Download Reasons"]

form create add_reason
element create add_reason download_reason_id -label "Reason ID" -datatype integer -widget hidden
element create add_reason reason -label "Reason" -datatype text -widget textarea -optional -html {rows 4 cols 40}


if { [form is_request add_reason] } {
    element set_properties add_reason download_reason_id -value [db_nextval acs_object_id_seq]
}

if { [form is_valid add_reason] } {
    form get_values add_reason
    db_dml repository_reasons_insert {
        insert into download_reasons (download_reason_id, repository_id, reason) values (:download_reason_id, :repository_id, :reason)
    }
    element set_properties add_reason download_reason_id -value [db_nextval acs_object_id_seq]
    element set_properties add_reason reason -value ""
}

db_multirow reasons reasons_select {
    select download_reason_id, reason from download_reasons where repository_id = :repository_id
}

ad_return_template