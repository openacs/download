# /packages/download/www/admin/repository-metadata-delete.tcl
ad_page_contract {
     Delete an archive type.
     @author jbank@arsdigita.com [jbank@arsdigita.com]
     @creation-date Tue Dec 12 16:46:37 2000
     @cvs-id
} {
    metadata_id:integer,notnull
}

set repository_id [download_repository_id]
ad_require_permission $repository_id "admin"

db_dml metadata_delete {
    delete from download_archive_metadata where metadata_id = :metadata_id
}

ad_returnredirect "repository-metadata"

