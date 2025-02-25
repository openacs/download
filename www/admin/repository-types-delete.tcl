# /packages/download/www/admin/repository-reasons-delete.tcl
ad_page_contract {
     Delete an archive type.
     @author jbank@arsdigita.com [jbank@arsdigita.com]
     @creation-date Tue Dec 12 16:46:37 2000
     @cvs-id $Id$
} {
    archive_type_id:naturalnum,notnull
}

set repository_id [download::repository_id]
permission::require_permission -object_id $repository_id -privilege "admin"

db_dml type_delete {
    delete from download_archive_types where repository_id = :repository_id and archive_type_id = :archive_type_id
}

ad_returnredirect "repository-types"
ad_script_abort

