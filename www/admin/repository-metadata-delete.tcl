# /packages/download/www/admin/repository-metadata-delete.tcl
ad_page_contract {
     Delete an archive type.
     @author jbank@arsdigita.com [jbank@arsdigita.com]
     @creation-date Tue Dec 12 16:46:37 2000
     @cvs-id $Id$
} {
    metadata_id:naturalnum,notnull
}

set repository_id [download::repository_id]
permission::require_permission -object_id $repository_id -privilege "admin"

db_dml metadata_delete {
    delete from download_archive_metadata where metadata_id = :metadata_id
}

ad_returnredirect "repository-metadata"
ad_script_abort

