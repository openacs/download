# /packages/download/www/one-archive.tcl
ad_page_contract {
     Display information about one archive.

     @author jbank@arsdigita.com [jbank@arsdigita.com]
     @creation-date Wed Dec 13 14:38:45 2000
     @cvs-id
} {
    archive_id:integer,notnull
}

ad_require_permission $archive_id read

set master_admin_p [ad_permission_p [ad_conn package_id] admin]
set admin_p [ad_permission_p $archive_id admin]
set write_p [ad_permission_p $archive_id write]

if ![db_0or1row archive_info_select {
   select da.archive_name, 
          da.summary,
          da.description, 
          da.description_type, 
          u.last_name || ', ' || u.first_names as creation_user_name,
          da.creation_user, 
          to_char(da.creation_date,'Mon DD, YYYY') as creation_date
     from download_archives_obj da, cc_users u
    where da.archive_id = :archive_id
      and u.user_id = da.creation_user
}] {
    ad_return_complaint 1 "The archive you are looking for (archive ID $archive_id) could not be found"
    return
}



if {[string eq $description_type {text/plain}]} { 
    set description [ad_text_to_html $description]
}

set pending_count [db_string pending_count_select {
        select count(*)
          from download_arch_revisions_obj dar
         where dar.archive_id = :archive_id
           and approved_p is null
    }]

db_multirow revisions rep_get_revisions {
    select dar.file_name,
           dar.version_name,
           dar.revision_id,
           u.last_name || ', ' || u.first_names as creation_user_name,
           dar.creation_user, 
           to_char(dar.creation_date,'Mon DD, YYYY') as creation_date
           
    from download_arch_revisions_obj dar, cc_users u
    where dar.archive_id = :archive_id
          and approved_p = 't' and
          u.user_id = dar.creation_user
    order by version_name
}

set context [list $archive_name]

set gc_link ""
set gc_comments ""
if { [catch {
    set gc_link [general_comments_create_link -object_name $archive_name $archive_id [ad_conn url]?[ad_conn query]]
    set gc_comments [general_comments_get_comments $archive_id [ad_conn url]?[ad_conn query]]
} error] } {
    global errorInfo errorCode
    ns_log Notice "gc_link: $errorInfo, $errorCode"
}


ad_return_template
