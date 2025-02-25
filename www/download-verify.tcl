# /packages/download/www/download-verify.tcl
ad_page_contract {

     @author jbank@arsdigita.com [jbank@arsdigita.com]
     @creation-date Wed Dec 13 00:23:21 2000
     @cvs-id $Id$
} {
    revision_id:naturalnum,notnull
}

set user_id [ad_conn user_id]
set repository_id [download::repository_id]

auth::require_login
permission::require_permission -object_id $revision_id -privilege "read"

set admin_p [permission::permission_p -object_id $repository_id -privilege admin]
set approval ""
if { $admin_p == 0 } {
    set approval "and dar.approved_p = 't'"
}

if {![db_0or1row revision_info_select "
select da.archive_id,
       da.repository_id as repository_id,
       da.archive_name,
       da.summary,
       dar.revision_id,
       dar.file_name,
       dar.version_name,
       dbms_lob.getlength(dar.content) as file_size
from   download_archives_obj da,
       download_arch_revisions_obj dar
where  da.archive_id = dar.archive_id and
       dar.revision_id = :revision_id
       $approval
"]} {
    ad_return_complaint 1 "[_ download.lt_The_version_you_are_l]"
    return
}

set context [list [list "one-archive?archive_id=$archive_id" $archive_name] "Download $archive_name $version_name"]

##TODO Get version name
set action "[ad_conn package_url]download/$file_name"

db_multirow reasons get_reasons {
    select reason, download_reason_id
    from download_reasons
    where repository_id = :repository_id
}

set download_id [db_nextval download_reasons_sequence]
ad_return_template
