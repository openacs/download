# /packages/download/www/download-verify.tcl
ad_page_contract {
     
     @author jbank@arsdigita.com [jbank@arsdigita.com]
     @creation-date Wed Dec 13 00:23:21 2000
     @cvs-id
} {
    revision_id:integer,notnull
}

set user_id [ad_verify_and_get_user_id]
set repository_id [download_repository_id]

ad_maybe_redirect_for_registration
ad_require_permission $revision_id "read"

set admin_p [ad_permission_p $repository_id admin]
set approval ""
if { $admin_p == 0 } {
    set approval "and dar.approved_p = 't'"
}

if ![db_0or1row revision_info_select "
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
"] {
    ad_return_complaint 1 "The version you are looking for (revision ID $revision_id) could not be found"
    return
}

# oracle version gets file_size from the blob
# postgres version can't (content is in fs, not db), 
#  so it gets content_path
#  and we can calculate file_size here

if { ![info exists file_size] } {
	set file_size [cr_file_size $content_path]
}

set context_bar [list [list "one-archive?archive_id=$archive_id" $archive_name] "Download $archive_name $version_name"]

##TODO Get version name
set action "[ad_conn package_url]download/$file_name"

set reason_widget [ad_db_select_widget -option_list {{"" "Other"}} reasons "
    select reason, download_reason_id from download_reasons where repository_id = $repository_id" reason_id]

set download_id [db_nextval download_reasons_seq]
ad_return_template