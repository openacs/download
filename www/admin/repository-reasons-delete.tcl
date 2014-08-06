# /packages/download/www/admin/repository-reasons-delete.tcl
ad_page_contract {
     Delete a reason.
     @author jbank@arsdigita.com [jbank@arsdigita.com]
     @creation-date Tue Dec 12 16:46:37 2000
     @cvs-id $Id$
} {
    download_reason_id:naturalnum,notnull
}

set repository_id [download_repository_id]
permission::require_permission -object_id $repository_id -privilege "admin"

db_dml reason_delete {
    delete from download_reasons where download_reason_id = :download_reason_id
}

ad_returnredirect "repository-reasons"

