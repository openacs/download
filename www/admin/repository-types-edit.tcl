# /packages/download/www/admin/repository-types-edit.tcl
ad_page_contract {
     
     @author jbank@arsdigita.com [jbank@arsdigita.com]
     @creation-date Wed Jan 10 18:34:23 2001
     @cvs-id $Id$
} {
    archive_type_id:integer,notnull
}

set repository_id [download_repository_id]
set user_id         [ad_verify_and_get_user_id]

ad_require_permission $repository_id "admin"

form create edit_type
element create edit_type archive_type_id -label "ArchiveType ID" -datatype integer -widget hidden
element create edit_type pretty_name -label "Name" -datatype text 
element create edit_type description -label "Description" -datatype text -widget textarea -html {rows 4 cols 40}

db_1row edit_info {select archive_type_id, pretty_name, description from download_archive_types where archive_type_id = :archive_type_id}
if { [form is_request edit_type] } {
    element set_properties edit_type archive_type_id -value $archive_type_id
    element set_properties edit_type pretty_name -value $pretty_name
    element set_properties edit_type description -value $description
}

if {[form is_valid edit_type]} {
    form get_values edit_type
    db_dml edit_type {
        update download_archive_types set pretty_name = :pretty_name, description = :description
        where archive_type_id = :archive_type_id
    }
    ad_returnredirect "repository-types"
}

set title "Edit $pretty_name"
set context [list [list "repository-types" "Repository Types"] $title]

ad_return_template
