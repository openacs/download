# /packages/download/www/one-revision.tcl
ad_page_contract {
     
     @author jbank@arsdigita.com [jbank@arsdigita.com]
     @creation-date Thu Dec 14 00:18:11 2000
     @cvs-id $Id$
} {
    revision_id:naturalnum,notnull
} -properties {
    title:onevalue
    admin_p:onevalue
    master_admin_p:onevalue    
}

set repository_id [download_repository_id]
set admin_p [ad_permission_p $revision_id "admin"]
set master_admin_p [ad_permission_p [ad_conn package_id] admin]

##FIXME: Need to do the metadata thing here!
ad_require_permission $revision_id "read"

set archive_type_id [db_string get_archive_type "select archive_type_id from download_arch_revisions_obj dar, download_archives da where dar.archive_id = da.archive_id and dar.revision_id = :revision_id"]

set metadata_selects ""
template::multirow create metadata pretty_name select_var
db_foreach metadata {
    select dam.metadata_id,
           dam.pretty_name,
           dam.data_type
    from download_archive_metadata dam
    where dam.repository_id = :repository_id and
          (dam.archive_type_id = :archive_type_id or dam.archive_type_id is null)
    order by sort_key
} {
    set answer_column [download_metadata_column $data_type]
    set metadata_select "metadata$metadata_id"
    template::multirow append metadata $pretty_name $metadata_select
    append metadata_selects ", (select $answer_column from download_revision_data where revision_id = :revision_id and metadata_id = $metadata_id) as $metadata_select
    "
}


if ![db_0or1row revision_info_select "         
select da.archive_id,
       dat.pretty_name as archive_type,
       da.archive_type_id,
       da.archive_name,
       da.summary,
       da.description,
       da.description_type,
       dar.revision_id,
       dar.file_name,
       dar.version_name,
       dar.version_name,
       dbms_lob.getlength(dar.content) as file_size,       
       (select count(*) from download_downloads where revision_id = dar.revision_id) as downloads,
       dar.approved_p,
       u.last_name || ', ' || u.first_names as creation_user_name,
       dar.creation_user, 
       dar.creation_date 
       $metadata_selects
from   download_archives_obj da,
       download_archive_types dat,
       download_arch_revisions_obj dar,
       cc_users u
where  da.repository_id = :repository_id and
       dat.archive_type_id = da.archive_type_id and
       da.archive_id = dar.archive_id and
       dar.revision_id = :revision_id and
       dar.creation_user = u.user_id
"] {
    ad_return_complaint 1 "The revision you are looking for (revision ID $revision_id) could not be found"
    return
}

if {[string eq $description_type {text/plain}]} { 
    set description [ad_text_to_html -- $description]
}

set context [list [list "one-archive?archive_id=$archive_id" $archive_name] "version $version_name"]
set gc_link ""
set gc_comments ""
if { [catch {
    set gc_link [general_comments_create_link -object_name "$archive_name $version_name" $revision_id [ad_conn url]?[ad_conn query]]
    set gc_comments [general_comments_get_comments $revision_id [ad_conn url]?[ad_conn query]]
} error] } {
    global errorInfo errorCode
    ns_log Notice "gc_link: $errorInfo, $errorCode"
}

ad_return_template
