# /packages/download/www/archive-add.tcl
ad_page_contract {
     Add a new archive.
     @author jbank@arsdigita.com [jbank@arsdigita.com]
     @creation-date Tue Dec 12 22:38:49 2000
     @cvs-id $Id$
} {
    archive_type_id:naturalnum,notnull
    {return_url "[ad_conn package_url]"}
}

auth::require_login
set context {"Add an Archive"}
set user_id [ad_conn user_id]

array set repository [download_repository_info]
set repository_id $repository(repository_id)
set title $repository(title)
set description $repository(description)
set help_text $repository(help_text)

set admin_p [permission::permission_p -object_id $repository_id -privilege admin]

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

ad_return_template