# /packages/download/www/admin/repository-types.tcl
ad_page_contract {
     Repository types
     @author jbank@arsdigita.com [jbank@arsdigita.com]
     @creation-date Tue Dec 12 15:58:00 2000
     @cvs-id $Id$
} {
}

set repository_id [download_repository_id [ad_conn package_id] 0]
ad_require_permission $repository_id "admin"

set title "Download Repository Archive Types"
set context [list "Archive Types"]

form create add_type
element create add_type archive_type_id -label "ArchiveType ID" -datatype integer -widget hidden
element create add_type pretty_name -label "Name" -datatype text 
element create add_type description -label "Description" -datatype text -widget textarea -html {rows 4 cols 40}

if { [form is_request add_type] } {
    element set_properties add_type archive_type_id -value [db_nextval acs_object_id_seq]
}

if {[form is_valid add_type]} {
    form get_values add_type
    db_dml repository_types_insert {
        insert into download_archive_types (archive_type_id, repository_id, pretty_name, description) values (:archive_type_id, :repository_id, :pretty_name, :description)
    }
    element set_properties add_type archive_type_id -value [db_nextval acs_object_id_seq]
    element set_properties add_type pretty_name -value ""
    element set_properties add_type description -value ""
}


db_multirow types types_select {
    select archive_type_id, pretty_name, description from download_archive_types where repository_id = :repository_id
}

ad_return_template