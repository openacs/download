# /packages/download/www/admin/repository-reasons-delete.tcl
ad_page_contract {
     Delete an archive type.
     @author jbank@arsdigita.com [jbank@arsdigita.com]
     @creation-date Tue Dec 12 16:46:37 2000
     @cvs-id $Id$
} {
    archive_type_id:integer,notnull
}

set repository_id [download_repository_id]
ad_require_permission $repository_id "admin"

db_dml type_delete {
    delete from download_archive_types where repository_id = :repository_id and archive_type_id = :archive_type_id
}

ad_returnredirect "repository-types"

