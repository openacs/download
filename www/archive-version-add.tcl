# /packages/download/www/archive-version-add.tcl
ad_page_contract {
     
     @author jbank@arsdigita.com [jbank@arsdigita.com]
     @creation-date Thu Dec 14 00:44:30 2000
     @cvs-id $Id$
} {
    archive_id:naturalnum,notnull
    {return_url ""}
}

if [empty_string_p $return_url] {
    set return_url "[ad_conn package_url]/one-archive?archive_id=$archive_id"
}

ad_maybe_redirect_for_registration
set repository_id [download_repository_id]

ad_require_permission $archive_id write

if ![db_0or1row archive_info_select {
   select da.archive_name, 
          da.archive_type_id,
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
    ad_return_complaint 1 "[_ download.lt_The_archive_you_are_l]"
    return
}

#FIXME: Do the conversion based on mime type
#set description [ad_format_text $description $description_type]
set extra_form_elts ""
db_foreach metadata {
    select 
      dam.metadata_id,
      dam.pretty_name,
      dam.data_type
    from download_archive_metadata dam
         where dam.repository_id = :repository_id and
               dam.computed_p = 'f' and
               (dam.archive_type_id = :archive_type_id or
                dam.archive_type_id is null)
    order by sort_key
} {
    append extra_form_elts [download_metadata_widget $data_type $pretty_name $metadata_id]
}

set context [list "[_ download.lt_Add_an_Revision_to_ar]"]

ad_return_template